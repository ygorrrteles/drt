import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dryve_teste/controllers/home_page_controller.dart';
import 'package:dryve_teste/models/brand_model.dart';
import 'package:dryve_teste/models/car_model.dart';
import 'package:dryve_teste/models/color_model.dart';
import 'package:dryve_teste/pages/widget/applyCleanButtons.dart';
import 'package:dryve_teste/repository/home_page_repository.dart';
import 'package:dryve_teste/utils/brand_image_filter.dart';
import 'package:dryve_teste/utils/color_filter_utils.dart';
import 'package:dryve_teste/utils/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Row(
          children: <Widget>[
            Image.asset("assets/images/wv logo.png"),
            Text(
              "VW Seminovos",
              style: GoogleFonts.roboto(color: Colours.brand, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
            ),
          ],
        ),
        elevation: 0,
        actions: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 60,
              child: FlatButton(
                padding: EdgeInsets.zero,
                child: Obx(
                  () => Badge(
                    showBadge: HomePageController.to.numberFilter == 0 ? false : true,
                    badgeContent: Obx(
                      () => Text(
                        "${HomePageController.to.numberFilter}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    badgeColor: Colors.blueAccent,
                    child: Icon(
                      Icons.tune,
                      color: Colours.details,
                    ),
                  ),
                ),
                onPressed: () {
                  Get.bottomSheet(bottomSheetFilter(), isScrollControlled: true);
                },
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await HomePageController.to.fetchAllCars();
        },
        child: Obx(
          () {
            if (HomePageController.to.appliedFilter.value && HomePageController.to.listCar.length == 0) {
              return widgetIfFilterAppliedAndListCarIsEmpty();
            }
            if (HomePageRepository.to.failFetchAllCars.value) {
              return widgetIfFailFetchAllCars();
            }
            if (HomePageController.to.listCar.length == 0) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (Get.width / (Get.height / 1.15)),
              padding: EdgeInsets.all(15),
              crossAxisSpacing: 20,
              children: List.generate(HomePageController.to.listCar.length, (index) {
                final model = HomePageController.to.listCar[index].obs;
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: model.value.imageUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 50,
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  model.value.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  model.update((val) {
                                    val.isFavorite = !val.isFavorite;
                                  });
                                  if (model.value.isFavorite) {
                                    await box.write("favoriteCar-${model.value.id}", model.value);
                                    print("salvando favoriteCar-${model.value.id}");
                                  } else {
                                    await box.remove("favoriteCar-${model.value.id}");
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      RichText(
                        text: TextSpan(
                          text: '${model.value.brandName}',
                          style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colours.brand, fontSize: 14, letterSpacing: 0.5),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' ${model.value.modelName}',
                              style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colours.model, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '${model.value.modelYear}',
                              style: GoogleFonts.roboto(color: Colours.details, fontSize: 14),
                            ),
                            TextSpan(
                              text: ' • ',
                              style: GoogleFonts.roboto(color: Colours.details, fontSize: 14),
                            ),
                            TextSpan(
                              text: '${model.value.fuelType}',
                              style: GoogleFonts.roboto(color: Colours.details, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        '${model.value.transmissionType} • ${NumberFormat().format(model.value.mileage)} km',
                        style: GoogleFonts.roboto(color: Colours.details, fontSize: 14),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        '${NumberFormat.currency(symbol: "R\$",locale: "pt_BR",decimalDigits: 0).format(model.value.price)}',
                        style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colours.price, fontSize: 16),
                      )
                    ],
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

Center widgetIfFailFetchAllCars() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Ops!"),
        SizedBox(
          height: 10,
        ),
        Text("Não foi possível buscar a lista de carros, tente mais tarde.!"),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            child: Text(
              "Limpar Filtros",
              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              HomePageController.to.fetchAllCars();
              HomePageController.to.fetchAllColors();
              HomePageController.to.fetchAllBrands();
            },
          ),
        )
      ],
    ),
  );
}

Center widgetIfFilterAppliedAndListCarIsEmpty() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Ops!"),
        SizedBox(
          height: 10,
        ),
        Text("Não encontramos nenhum veículo com essas características.!"),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey)),
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            child: Text(
              "Limpar Filtros",
              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
            onPressed: HomePageController.to.resetFilter,
          ),
        )
      ],
    ),
  );
}

Widget bottomSheetFilter() {
  return FractionallySizedBox(
    heightFactor: 0.8,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Get.focusScope.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 50,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                        color: Colours.details,
                      ),
                      onPressed: Get.back,
                    ),
                  ),
                  Text("Filtrar",style: GoogleFonts.roboto(color: Colours.brand,fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Marcas",style: GoogleFonts.roboto(color: Colours.brand,fontSize: 18, fontWeight: FontWeight.bold),),
                    SizedBox(height: 25,),
                    Container(
                      padding: EdgeInsets.zero,
                      child: TextField(
                        controller: HomePageController.to.filterController.value,
                        onChanged: (_) => HomePageController.to.setFilterMarcas(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Buscar por nome...",
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Obx(
                      () => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: HomePageController.to.listBrands.length,
                        itemBuilder: (context, index) {
                          final brand = HomePageController.to.listBrands[index].obs;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Obx(
                              () => Checkbox(
                                onChanged: (_) {
                                  print(brand.value.checked);
                                  HomePageController.to.checkBrand(brand);
                                },
                                value: brand.value.checked,
                              ),
                            ),
                            title: Row(
                              children: <Widget>[
                                Image.asset(BrandFilterUtils.idBrandToLogo(int.parse(brand.value.brandId))),
                                SizedBox(width: 20,),
                                Text("${brand.value.name.capitalize}",style: GoogleFonts.roboto(color: Colours.details,fontSize: 16),),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    SizedBox(height: 20,),
                    Text("Cor",style: GoogleFonts.roboto(color: Colours.brand,fontSize: 18, fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    Obx(
                      () => GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        childAspectRatio: 4,
                        children: List.generate(
                          HomePageController.to.listColor.length,
                          (index) {
                            final color = HomePageController.to.listColor[index].obs;
                            return Container(
                              width: 100,
                              child: FlatButton(
                                onPressed: () {
                                  HomePageController.to.checkColor(color);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          border: color.value.checked ? Border.all(color: Colors.blueAccent, width: 2) : Border.all(color: Colors.grey, width: 1),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: ColorFilterUtils.idColorToColor(int.parse(color.value.colorId))),
                                      child: Visibility(
                                        visible: color.value.checked,
                                        child: Center(
                                          child: Icon(
                                            Icons.check,
                                            size: 20,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("${color.value.name}",style: GoogleFonts.roboto(color: Colours.details,fontSize: 16),)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ApplyCleanButtons(
                      applyButton: () {
                        HomePageController.to.resetFilter();
                      },
                      cleanButton: () {
                        HomePageController.to.applyFilter();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
