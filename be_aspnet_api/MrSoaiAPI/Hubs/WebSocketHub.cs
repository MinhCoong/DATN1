using Microsoft.AspNetCore.SignalR;
namespace MrSoaiAPI.Hubs
{
    public class WebSocketHub : Hub
    {
        public override async Task OnConnectedAsync()
        {
            await Clients.All.SendAsync("OrderMessage", "Connected");
        }
    }
}
