import 'dart:ui';

import 'package:challenges/shared/flutter_three/core/buffer_geometry.dart';
import 'package:challenges/shared/flutter_three/objects/mesh.dart';
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math.dart'
    show Plane, Vector3, Vector2, Vector4, Aabb3, Sphere, Matrix4;

class MorphTarget {
  const MorphTarget(this.name, this.vertices);

  final String name;
  final Vector3 vertices;
}

// class MorphColor {
//   const MorphColor(this.name, this.colors);

//   final String name;
//   final List<Color> colors;
// }

class MorphNormals {
  const MorphNormals(this.name, this.normals);

  final String name;
  final Vector3 normals;
}

class Geometry extends Listenable {
  /// Unique number of this geometry instance
  Key key;

  /// Name for this geometry. Default is an empty string.
  String name = '';

  /// The array of vertices hold every position of points of the model.
  /// To signal an update in this array, Geometry.verticesNeedUpdate needs to be set to true.
  List<Vector3> vertices;

  List<Color> colors;

  /// Array of triangles or/and quads.
  /// The array of faces describe how each vertex in the model is connected with each other.
  /// To signal an update in this array, Geometry.elementsNeedUpdate needs to be set to true.
  List<Plane> faces;

  /// Array of face UV layers.
  /// Each UV layer is an array of UV matching order and number of vertices in faces.
  /// To signal an update in this array, Geometry.uvsNeedUpdate needs to be set to true.
  List<List<List<Vector2>>> faceVertexUvs;

  /// Array of morph targets. Each morph target is a Javascript object:
  /// 	 *
  /// 		 { name: "targetName", vertices: [ new THREE.Vector3(), ... ] }
  /// 	 *
  /// Morph vertices match number and order of primary vertices.
  List<MorphTarget> morphTargets;

  /// Array of morph normals. Morph normals have similar structure as morph targets, each normal set is a Javascript object:
  /// 	 *
  /// 		 morphNormal = { name: "NormalName", normals: [ new THREE.Vector3(), ... ] }
  List<MorphNormals> morphNormals;

  /// Array of skinning weights, matching number and order of vertices.
  Vector4 skinWeights;

  /// Array of skinning indices, matching number and order of vertices.
  Vector4 skinIndices;

  List<int> lineDistances;

  /// Bounding box.
  Aabb3 boundingBox;

  /// Bounding sphere.
  Sphere boundingSphere;

  /// Set to true if the vertices array has been updated.
  bool verticesNeedUpdate;

  /// Set to true if the faces array has been updated.
  bool elementsNeedUpdate;

  /// Set to true if the uvs array has been updated.
  bool uvsNeedUpdate;

  /// Set to true if the normals array has been updated.
  bool normalsNeedUpdate;

  /// Set to true if the colors array has been updated.
  bool colorsNeedUpdate;

  /// Set to true if the linedistances array has been updated.
  bool lineDistancesNeedUpdate;

  bool groupsNeedUpdate;

  Geometry applyMatrix4(Matrix4 matrix) {
    return this;
  }

  Geometry rotateX(double angle) {
    return this;
  }

  Geometry rotateY(double angle) {
    return this;
  }

  Geometry rotateZ(double angle) {
    return this;
  }

  Geometry translate(double x, double y, double z) {
    return this;
  }

  Geometry scale(double x, double y, double z) {
    return this;
  }

  void lookAt(Vector3 vector) {}

  Geometry fromBufferGeometry(BufferGeometry geometry) {
    return this;
  }

  Geometry get center => this;
  Geometry get normalize => this;

  /// Computes face normals.
  void computeFaceNormals() {}

  /// Computes vertex normals by averaging face normals.
  /// Face normals must be existing / computed beforehand.
  void computeVertexNormals([bool areaWeighted = true]) {}

  /// Compute vertex normals, but duplicating face normals.
  void computeFlatVertexNormals() {}

  /// Computes morph normals.
  void computeMorphNormals() {}

  /// Computes bounding box of the geometry, updating {@link Geometry.boundingBox} attribute.
  void computeBoundingBox() {}

  /// Computes bounding sphere of the geometry, updating Geometry.boundingSphere attribute.
  /// Neither bounding boxes or bounding spheres are computed by default. They need to be explicitly computed, otherwise they are null.
  void computeBoundingSphere() {}

  // TODO: original specifies just a Matrix... superclass of Matrix4/3
  void merge(Geometry geometry, [Matrix4 matrix, int materialIndexOffset]) {}

  void mergeMesh(Mesh mesh) {}

  /// Checks for duplicate vertices using hashmap.
  /// Duplicated vertices are removed and faces' vertices are updated.
  int mergeVertices() {
    return null;
  }

  Geometry setFromPoints({List<Vector2> points2, List<Vector3> points3}) {
    return this;
  }

  void sortFacesByMaterialIndex() {}

  String toJson() {
    return null;
  }

  /// Creates a new clone of the Geometry.
  Geometry clone() {
    return this;
  }

  Geometry copy(Geometry source) {
    return this;
  }

  /// Removes The object from memory.
  /// Don't forget to call this method when you remove an geometry because it can cuase meomory leaks.
  void dispose() {}

  // These properties do not exist in a normal Geometry class, but if you use the instance that was passed by JSONLoader, it will be added.
  // List<Bone> bones;
  // AnimationClip animation;
  // List<AnimationClip> animations;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }
}
