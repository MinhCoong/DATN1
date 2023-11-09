using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model.Authentication;
using System.Data;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/[controller]")]
    [ApiController]
    public class NotificationsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public NotificationsController(MrSoaiAPIContext context)
        {
            _context = context;
        }
        
        [HttpPost("send-notification-to-user/{userId}")]
        public async Task<IActionResult> SendNotificationToUser([FromForm] string userId, string title, string body)
        {
            var user = await _context.Users.SingleOrDefaultAsync(i=>i.Id == userId);
            if (user == null)
            {
                return BadRequest();
            }
            if (FirebaseApp.DefaultInstance == null)
            {
                FirebaseApp.Create(new AppOptions()
                {
                    Credential = GoogleCredential.FromFile("Firebase/serviceAccountKey.json"),
                });
            }

            var listToken = _context.RegistrationTokens.Where(i=>i.UserId == user.Id).ToList();
            if(listToken==null)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "Not Found Any regisToken" });
            }
            
            List<string> registrationTokens = new();
            foreach (var token in listToken)
            {
                registrationTokens.Add(token.DeviceToken);
            }
            //var registrationToken = "cn0t46B-SNWYlm0e10CP7Q:APA91bHx6MAGygK4FMdrD9HW1BNu3wOv2Y0etr9S8QAoqn7sriYcgu3y9o0NBmDqiwOOkbnIfQCyX_qnutXaQC-zkcSVwvnPmKutqtoIiOAzuOrQtgFBQMDxh89C7Ct7Rn4d16Efl0Xb";
            var message = new MulticastMessage()
            {
                Tokens = registrationTokens,
              Notification = new FirebaseAdmin.Messaging.Notification()
              {
                  Title=title,
                  Body=body,
              },
            };

            var response = await FirebaseMessaging.DefaultInstance.SendMulticastAsync(message);
            Console.WriteLine($"{response.SuccessCount} messages were sent successfully");
            if (response.FailureCount > 0)
            {
                var failedTokens = new List<string>();
                for (var i = 0; i < response.Responses.Count; i++)
                {
                    if (!response.Responses[i].IsSuccess)
                    {
                        // The order of responses corresponds to the order of the registration tokens.
                        failedTokens.Add(registrationTokens[i]);
                    }
                }

                Console.WriteLine($"List of tokens that caused failures: {failedTokens}");
            }
            else
            {
                var notification = new Model.Notification()
                {
                    UserId = user.Id,
                    Title = title,
                    Body = body,
                    CreatedAt = DateTime.Now,
                    Status = true
                };
                _context.Notifications.Add(notification);
                _context.SaveChanges();
            }

            return Ok(response);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("send-notification-to-all-user")]
        public async Task<IActionResult> SendNotificationToAllUser([FromForm] string title, string body)
        {
            if (FirebaseApp.DefaultInstance == null)
            {
                FirebaseApp.Create(new AppOptions()
                {
                    Credential = GoogleCredential.FromFile("Firebase/serviceAccountKey.json"),
                });
            }

            // The topic name can be optionally prefixed with "/topics/".
            var topic = "AllUser";

            // See documentation on defining a message payload.
            var message = new Message()
            {
                Notification = new FirebaseAdmin.Messaging.Notification()
                {
                    Title = title,
                    Body = body,

                },
                Topic = topic,
            };

            // Send a message to the devices subscribed to the provided topic.
            string response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
            // Response is a message ID string.
            Console.WriteLine("Successfully sent message: " + response);
                   
            var notification = new Model.Notification()
            {
                UserId = "AllUser",
                Title = title,
                Body = body,
                CreatedAt = DateTime.Now,
                Status = true
            };
            _context.Notifications.Add(notification);
            _context.SaveChanges();        

            return Ok(response);
        }
        [Authorize(Roles = "Admin,Staff")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Model.Notification>>> GetNews()
        {
            return await _context.Notifications.Where(i=>i.Status==true).ToListAsync();
        }
        [Authorize(Roles = "Admin")]
        [HttpDelete]
        public async Task<IActionResult> DeleteNotification(int id)
        {
            var noti = await _context.Notifications.FindAsync(id);
            if (noti == null)
            {
                return BadRequest();
            }

            noti.Status = false;
            _context.Entry(noti).State = EntityState.Modified;
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException e)
            {
                Console.WriteLine(e);
            }

            return NoContent();
        }

    }
}
