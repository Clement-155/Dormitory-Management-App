import 'dart:ffi';

class UserModel {
  final String email;
  final String nama;
  final String tanggal_lahir;
  final Int jenis_kelamin; //0 = Laki2, 1 = Perempuan, 2 = Others
  final String no_hp;
  final String tanggal_masuk_kost; // Update saat join kost, default = '1925-01-01 00-00:00.000'
  final Int role; //0 = Penghuni atau 1 = pemilik. Dibuat int seandainya butuh role lain
  final Int status; //-1 = pemilik, 0 = Bukan anggota kost, 1 = belum bayar, 2 = sudah bayar, 3 = telat bayar


  const UserModel(this.email, this.nama, this.tanggal_lahir, this.jenis_kelamin, this.no_hp, this.tanggal_masuk_kost, this.role, this.status);

  Map<String, dynamic> mapModel(){
    return {
      'email': this.email,
      'nama': this.nama,
      'tanggal_lahir': this.tanggal_lahir,
      'jenis_kelamin': this.jenis_kelamin,
      'no_hp': this.no_hp,
      'tanggal_masuk_kost': this.tanggal_masuk_kost ?? '1925-01-01 00-00:00.000',
      'role': this.role,
      'status': this.role == 1 ? -1 : 0
    };
  }
}