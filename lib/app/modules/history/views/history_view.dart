import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:miva_pos_app/app/widgets/miva_card.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 55,
        title: const Text(
          'Riwayat Struk',
          style: TextStyle(
              fontFamily: "Inter",
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF40228C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 30,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Periode Struk",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(12),
                    MivaCard.outline(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1 Agu 2024 ~",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "8 Agu 2024",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 5),
                                alignment: Alignment.center,
                              ),
                              onPressed: () {},
                              child: const Text(
                                "Ganti",
                                style: TextStyle(
                                  // color: Color(0xff3C2387),
                                  fontFamily: "Inter",
                                  // fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(12),
                    const Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        MivaCard.filled(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Jumlah Struk",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "11",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        MivaCard.filled(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Penjualan",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Rp250.000.000",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        MivaCard.filled(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Profit",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Rp25.000.000",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Gap(24),
                    const Text(
                      "Pencarian",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(12),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              FontAwesomeIcons.search,
                              size: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 232, 232, 232),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 232, 232, 232),
                                width: 1,
                              ),
                            ),
                            isDense: true),
                      ),
                    ),
                    const Gap(24),
                    const Text(
                      "Urut",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.sortOptions.map((option) {
                        return Obx(
                          () => RadioListTile<String>(
                            visualDensity: VisualDensity.compact,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            title: Text(option),
                            value: option,
                            groupValue: controller.selectedOption.value,
                            onChanged: (String? value) {
                              controller.setSelectedOption(value!);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 70,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daftar Struk",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                        child: MasonryGridView.count(
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 20,
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 1080 ? 2 : 1,
                      itemBuilder: (context, index) {
                        return MivaCard.outline(
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 30,
                                        decoration: const BoxDecoration(
                                            color: Color(0xff3C2387),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                bottomRight:
                                                    Radius.circular(12))),
                                        child: Center(
                                          child: Text(
                                            (index + 1).toString(),
                                            style: const TextStyle(
                                              fontFamily: "Inter",
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(8),
                                      const Text(
                                        "#276/240801",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(6),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jum, 8 Aug 2024 - 13.03",
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            color: Color(0xff7C7C7C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Gap(6),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.solidCircleUser,
                                              color: Color(0xff333333),
                                              size: 16,
                                            ),
                                            Gap(4),
                                            Text(
                                              "Nouval",
                                              style: TextStyle(
                                                fontFamily: "Inter",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (index % 3 == 0)
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Diskon",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Color(0xff7C7C7C),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Gap(6),
                                          Text(
                                            "- Rp.5000",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    const Gap(2),
                                    if (index % 3 == 0)
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Tambahan",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Color(0xff7C7C7C),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Gap(6),
                                          Text(
                                            "+ Rp.2000",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    const Gap(12),
                                    const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "5 Item",
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            color: Color(0xff7C7C7C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Gap(8),
                                        Icon(
                                          FontAwesomeIcons.solidCircle,
                                          size: 6,
                                          color: Color.fromARGB(
                                              255, 158, 158, 158),
                                        ),
                                        Gap(8),
                                        Text(
                                          "Rp250.000",
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: 12,
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
