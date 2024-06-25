import 'package:card/config/game_instructions.dart';
import 'package:card/main.dart';
import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button_small.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Palette.homeBackgroundGradientTop,
                      Palette.homeBackgroundGradientBottom
                    ],
                  ),
                ),
                child: Stack(children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 145,
                      width: 145,
                      child: Image.asset('assets/images/logo.png',
                          fit: BoxFit.cover,
                          opacity: AlwaysStoppedAnimation(0.15)),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(children: [
                      const Gap(30),
                      Text(
                        "Hướng Dẫn",
                        style: TextStyles.screenTitle
                            .copyWith(color: Palette.black),
                      ),
                      const Gap(30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          GameInstructions.instructions +
                              "\n2. Tính quan trọng của từng lá bài trong Xì Dách\n" +
                              "- Các lá bài từ 2 đến 10 có giá trị điểm tương ứng với số trên lá. Ví dụ, lá bài 3 (cơ) sẽ có giá trị là 3 điểm.\n" +
                              "- Các lá bài J, Q và K đều được tính là 10 điểm.\n" +
                              "3. Hướng dẫn chơi Xì Dách cơ bản\n" +
                              "Một người sẽ là người chia bài, sử dụng bộ bài 52 lá để phân phối cho mỗi người tham gia (nhà con) và cho mình (nhà cái) là 2 lá.\n" +
                              "Sau đó, người chơi có thể rút thêm tối đa 3 lá bài nữa, tức là người chơi có thể có tới 5 lá bài trong mỗi ván.\n" +
                              "Mục tiêu của việc rút bài này là để tổng giá trị các lá bài mình cầm gần hoặc bằng 21 càng tốt. Nếu không ai vượt qua được điểm số của bạn mà không quá 21 điểm, bạn sẽ tăng cơ hội chiến thắng của mình lên cao.\n" +
                              "Ở giai đoạn 1: Tính điểm của 2 lá bài\n" +
                              "- Khi bạn có bộ bài như vậy, bạn sẽ được hưởng lợi:\n" +
                              "+ Xì bàng: 2 lá Át\n" +
                              "+ Xì dách: 1 lá Át và 1 lá 10, J, Q hoặc K\n" +
                              "Nếu nhà cái có bài như vậy, cơ hội chiến thắng của nhà con sẽ cao hơn (trừ khi nhà con có bài bằng hoặc cao hơn)\n" +
                              "Ở giai đoạn 2: Rút thêm lá\n" +
                              "- Điều 1: Mỗi người được nhận 2 lá bài\n" +
                              "- Điều 2: Mỗi người kiểm tra bài, tính điểm và quyết định có rút thêm lá không.\n" +
                              "- Điều 3: Khi mọi người ngừng rút, đến lượt nhà cái. Nhà cái có quyền xét duyệt và tiếp tục rút bài.\n" +
                              "Sau khi tính điểm 2 lá bài ban đầu, người chơi có thể rút thêm hoặc dừng để tổng điểm từ 16 - 21.\n" +
                              "+ Không đủ: Bài trên tay dưới 16 điểm\n" +
                              "+ Đủ: Bài trên tay có điểm từ 16 - 21\n" +
                              "+ Vượt quá (quắc): Bài có điểm cao hơn 21. Người nào có điểm lớn hơn 21 sẽ không được rút thêm\n" +
                              "Vòng chơi: Bắt đầu từ nhà cái theo chiều kim đồng hồ. Mỗi người sẽ rút bài cho đến khi dừng. Người chơi cần có trên 16 điểm trước khi so bài. Nếu không, nhà con sẽ thua. Sau khi so bài, nếu nhà cái cao hơn nhà con, nhà cái sẽ chiến thắng. Ngược lại, nhà con sẽ thắng. Nếu hai bên bằng điểm nhau, sẽ hòa.\n" +
                              "4. Tình huống đặc biệt khi chơi Xì dách\n" +
                              "Người chơi sẽ đối mặt với các tình huống sau:\n" +
                              "- Ngũ linh: Tổng điểm 5 lá bài nhỏ hơn 21 sẽ dẫn đến chiến thắng tuyệt đối. Trong trường hợp cả hai đều có ngũ linh, người có tổng điểm thấp hơn sẽ thắng.\n" +
                              "5. Lưu ý\n" +
                              "Khi tham gia Xì dách, bạn sẽ gặp các tình huống sau và áp dụng cách tính điểm như sau:\n" +
                              "- Cả nhà cái và người chơi có bài quắc (vượt quá 21) hoặc cùng điểm, kết quả là hòa, không ai thua cược.\n" +
                              "- Cả nhà cái và người chơi có Xì bàng, kết quả là hòa, không ai thua cược.\n" +
                              "- Cả nhà cái và người chơi có Xì dách, kết quả là hòa, không ai thua cược.\n" +
                              "- Cả nhà cái và người chơi có ngũ linh, người có tổng điểm ít hơn sẽ thắng.\n" +
                              "6. Thuật ngữ Xì dách quan trọng\n" +
                              "Khi tham gia Xì dách trực tuyến, bạn thường xuyên gặp các thuật ngữ sau. Hãy tham khảo để trở thành một cao thủ Xì dách.\n" +
                              "- Rút thêm: Bổ sung 1 lá vào bộ bài\n" +
                              "- Dừng: Không cần thêm lá nào nữa\n" +
                              "- Gấp đôi: Đặt cược gấp đôi và nhận thêm 1 lá\n" +
                              "- Tách bài: Khi hai lá đầu giống nhau, bạn có thể tách thành hai tay và chơi tiếp. Mỗi tay có thêm 1 lá, cược như ban đầu.\n" +
                              "- Bảo hiểm: Khi nhà cái có lá Át, bạn có thể chọn bảo hiểm. Quyết định này thuộc về bạn, có đặt cược hay không.\n",
                          style: TextStyles.instructions,
                        ),
                      ),
                      CustomElevatedButtonSmall(
                        width: 150,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: const [
                            Palette.settingDialogButtonBackgroundGradientBottom,
                            Palette.settingDialogButtonBackgroundGradientTop
                          ],
                        ),
                        onPressed: () {
                          context.pop();
                        },
                        text: "Đã Hiểu",
                      ),
                      const Gap(50),
                    ]),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const MyApp(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
