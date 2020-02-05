import 'dart:ui';

import 'package:challenges/shared/flutter_three/core/geometry.dart';
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math.dart'
    show Vector3, Vector2, Vector4, Aabb3, Sphere;

import 'group.dart';

class DirectGeometry {
  Key key;
  String name;
  List<int> indices;
  List<Vector3> vertices;
  List<Vector3> normals;
  List<Color> colors;
  List<Vector2> uvs;
  List<Vector2> uvs2;
  List<Group> groups;

  List<MorphTarget> morphTargets;
  List<Vector4> skinWeights;
  List<Vector4> skinIndices;
  Aabb3 boundingBox;
  Sphere boundingSphere;

  bool verticesNeedUpdate;
  bool normalsNeedUpdate;
  bool colorsNeedUpdate;
  bool uvsNeedUpdate;
  bool groupsNeedUpdate;

  void computeBoundingBox() {}
  void computeBoundingSphere() {}
  void computeGroups(Geometry geometry) {}

  DirectGeometry fromGeometry(Geometry geometry) {
    return this;
  }

  void dispose() {}
}
