// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../components/widgets/big_text.dart';

class BenefitScreen extends StatelessWidget {
  const BenefitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.WH,
          toolbarHeight: Dimensions.heightListtile,
          elevation: 4,
          title: BigText(
            text: 'Quyền lợi',
            fontweight: FontWeight.w800,
            color: Colors.black.withOpacity(.9),
          ),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
            child: Column(
              children: [
                BigText(
                  text: 'CHÍNH SÁCH CHƯƠNG TRÌNH THÀNH VIÊN MR SOÁI 2023'
                      '\n-----------------------------------------------------'
                      '\nĐIỀU KIỆN THAM GIA '
                      '\nĐể tham gia chương trình thành viên Mr Soái, khách hàng cần tải ứng dụng Mr Soái food Google Play (Android) và đăng ký tài khoản thành viên.'
                      '\nChương trình chỉ áp dụng cho khách hàng cá nhân, không áp dụng cho nhóm, công ty, tập thể với mục đích thương mại dưới mọi hình thức. '
                      '\nMỗi khách hàng chỉ được sở hữu (01) tài khoản thành viên Mr Soái. '
                      '\nĐĂNG KÝ TÀI KHOẢN'
                      "\nBạn tham gia vào chương trình thành viên Mr Soái theo các bước sau:"
                      "\nBước 1: Tải ứng dụng Mr Soái trên Google Play (Android)"
                      "\nBước 2: Cung cấp số điện thoại và nhập mã OTP để hoàn tất đăng ký tài khoản"
                      '\nQUY ĐỊNH VỀ TÍCH LŨY CA '
                      '\nTrên ứng dụng Mr Soái, điểm thưởng được gọi là “CA”'
                      '\nVới mỗi 10.000 VNĐ chi tiêu thông qua ứng dụng Mr Soái, khách hàng sẽ tích được 01 CA. Nếu thanh toán ra số CA lẻ sẽ được chuyển thành số CA gần nhất.'
                      '\n(Ví dụ: khách hàng chi tiêu 29.000 VNĐ thông qua ứng dụng Mr Soái, khách hàng sẽ tích được 3 CAS vào tài khoản thành viên)'
                      '\nCAS chỉ được tích dựa trên chi tiêu qua các giao dịch trên ứng dụng Mr Soái.'
                      '\nCAS sẽ được tích dựa trên số tiền thanh toán cuối cùng của mỗi giao dịch, không bao gồm các mã quà tặng, mã giảm giá, hay các chương trình khuyến mãi khác từ Mr Soái.'
                      // '\nCAS sẽ được tích vào tài khoản khách hàng ngay sau khi trạng thái đơn hàng trên ứng dụng Mr Soái là HOÀN TẤT.'
                      '\nTrong trường hợp đơn hàng phát sinh các sự cố liên quan đến trả hàng và hoàn tiền, cas đã được tích trước đó sẽ được thu hồi.'
                      '\n Nếu số CAS khách hàng càng cao sẽ nhận được thêm nhiều ưu đã hấp dẫn',
                  overFlow: TextOverflow.visible,
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ));
  }
}
