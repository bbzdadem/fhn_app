import 'package:flutter/material.dart';

String terms =
    "ŞƏXSİ MƏLUMATLARIN QORUNMASI Şəxsi məlumat deyərkən müştərilərin FHN-nin xidmətlərindən istifadə zamanı şirkətə təqdim etdiyi bütün məlumatlar nəzərdə tutulur. ŞƏXSİ MƏLUMATLARIN QORUNMA PRİNSİPLƏRİ Ümumi prinsiplər: FHN  aşağıda qeyd edilən məqsədlərlə müştərinin  şəxsi məlumatlarını istifadə edə və ya açıqlaya bilər: - Xidmət seçimlərinizi təyin etmək üçün - İnformasiya, təbliğat, məhsul və xidmətlərimiz və ya reklam materiallarını sizə göndərmək üçün - FHN -nin maraqlarını qorumaq üçün - Ədalət mühakiməsi üçün - Sizin maraqlarınıza uyğun olduğunu düşündüyümüz, FHN  xidmətləri və ya üçüncü tərəfin xüsusi təkliflərini təbliğ etmək üçün FHN  qeydiyyat formasında tələb edilən şəxsi məlumatları Azərbaycan Respublikası Dövlət Gömrük Komitəsi tələblərinə və ehtiyaclarınıza uyğun daha yaxşı xidmət göstərmək məqsədi ilə toplayı Təhlükəsizlik prinsiplər FHN şəxsi məlumatların səhvən silinməsi və ya açıqlanmaması üçün Şəxsi Məlumatların gizliliyi və təhlükəsizliyini qorumaq məqsədilə təşkilati və texniki addımlar da daxil olmaqla bütün ehtiyat tədbirlərinin görülməsinə məsuliyyət daşıyı Müştəri Qeydiyyat Formasında tələb edilən məlumatlara verilən cavablara görə məsuliyyət daşıyır. Əgər Qeydiyyat formasında tələb edilən məlumatlara natamam və ya qeyri-dəqiq cavab verilsə, bu, müştəriyə göstərilən xidmətin dayandırılması və ya xidmətin tamamilə sonlandırılması ilə nəticələnə bilər. FHN  müştərilərinin şəxsi məlumatlarının qorunmasına cavabdehdir.";

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Qaydalar',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(terms),
      )),
    );
  }
}
