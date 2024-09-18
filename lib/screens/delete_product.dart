import 'package:http/http.dart';

class DeleteProduct{
  final String id;

  DeleteProduct({required this.id}){
    deleteProduct(id);
  }

  Future<int> deleteProduct(id) async{
    Uri uri = Uri.parse("http://164.68.107.70:6060/api/v1/DeleteProduct/$id");
    Response response = await get(uri);
    print(response);
    print(response.statusCode);
    print(response.body);

    return response.statusCode;
  }
}