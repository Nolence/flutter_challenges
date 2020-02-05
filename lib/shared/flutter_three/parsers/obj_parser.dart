import 'package:vector_math/vector_math.dart' show Vector3;

class SimpleGeometry {
  const SimpleGeometry(this.vertices, this.faces);

  final List<Vector3> vertices;
  final List<List<int>> faces;
}

SimpleGeometry parseObjString(String objString) {
  final vertices = <Vector3>[];
  final faces = <List<int>>[];
  var face = <int>[];

  List lines = objString.split("\n");

  Vector3 vertex;

  lines.forEach((dynamic line) {
    String lline = line;
    // Remove whitespace at end of lines
    lline = lline.replaceAll(RegExp(r"\s+$"), "");
    // Split on whitespace
    List<String> chars = lline.split(RegExp(r"\s+")); // TODO: PR

    // vertex
    if (chars[0] == "v") {
      // v    0.000000    2.000000    2.000000
      vertex = Vector3(
        double.parse(chars[1]),
        double.parse(chars[2]),
        double.parse(chars[3]),
      );

      vertices.add(vertex);

      // face indexes (1-based) into vertices when drawing.
    } else if (chars[0] == "f") {
      // f 5 6 2 1
      // # The first number is the point, then the slash, and the second is the texture point
      // f 1/1 2/2 3/3 4/4
      for (var i = 1; i < chars.length; i++) {
        face.add(int.parse(chars[i].split("/")[0]));
      }

      faces.add(face);
      face = [];
    }
  });

  return SimpleGeometry(vertices, faces);
}
