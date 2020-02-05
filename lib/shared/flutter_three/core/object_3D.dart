import 'package:challenges/shared/flutter_three/core/camera.dart';
import 'package:challenges/shared/flutter_three/core/geometry.dart';
import 'package:challenges/shared/flutter_three/core/group.dart';
import 'package:challenges/shared/flutter_three/core/intersection.dart';
import 'package:challenges/shared/flutter_three/core/layers.dart';
import 'package:challenges/shared/flutter_three/core/material.dart';
import 'package:challenges/shared/flutter_three/core/raycaster.dart';
import 'package:challenges/shared/flutter_three/scenes/scene.dart';
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math.dart'
    show Quaternion, Vector3, Matrix4, Matrix3;

class Object3D {
  Object3D(
    this.position,
    this.rotation,
    this.quaternion,
    this.scale,
    this.modelViewMatrix,
    this.normalMatrix,
  );

  /// Optional name of the object (doesn't need to be unique).
  String name;

  /// A unique key of this object instance.
  Key key;

  /// Object's parent in the scene graph.
  Object3D parent;

  /// Array with object's children.
  List<Object3D> children;

  /// Up direction. Defaults to Vector3( 0, 1, 0 )
  Vector3 up;

  /// Object's local position.
  final Vector3 position;

  /// Object's local rotation (Euler angles), in radians.
  final double rotation;

  /// Global rotation.
  final Quaternion quaternion;

  /// Object's local scale.
  final Vector3 scale;

  // TODO: Add doc
  final Matrix4 modelViewMatrix;

  // TODO: Add doc
  final Matrix3 normalMatrix;

  /// Local transform.
  Matrix4 matrix;

  /// The global transform of the object. If the Object3D has no parent, then it's identical to the local transform.
  Matrix4 matrixWorld;

  /// When this is set, it calculates the matrix of position, (rotation or quaternion) and scale every frame and also recalculates the matrixWorld property.
  bool matrixAutoUpdate;

  /// When this is set, it calculates the matrixWorld in that frame and resets this property to false.
  bool matrixWorldNeedsUpdate;

  Layers layers;

  /// Object gets rendered if true.
  bool visible;

  /// Gets rendered into shadow map.
  bool castShadow;

  /// Material gets baked in shadow receiving.
  bool receiveShadow;

  /// When this is set, it checks every frame if the object is in the frustum of the camera. Otherwise the object gets drawn every frame even if it isn't visible.
  bool frustumCulled;

  /// Overrides the default rendering order of scene graph objects, from lowest to highest renderOrder. Opaque and transparent objects remain sorted independently though. When this property is set for an instance of Group, all descendants objects will be sorted and rendered together.
  int renderOrder;

  /// An object that can be used to store custom data about the Object3d. It should not hold references to functions as these will not be cloned.
  Map<String, dynamic> userData;

  /// Custom depth material to be used when rendering to the depth map. Can only be used in context of meshes.
  /// When shadow-casting with a DirectionalLight or SpotLight, if you are (a) modifying vertex positions in
  /// the vertex shader, (b) using a displacement map, (c) using an alpha map with alphaTest, or (d) using a
  /// transparent texture with alphaTest, you must specify a customDepthMaterial for proper shadows.
  Material customDepthMaterial;

  Material customDistanceMaterial;

  final isObject3D = true;

  /// Calls before rendering object
  void onBeforeRender(
    Scene scene,
    Camera camera,
    Geometry geometry,
    Material material,
    Group group,
  ) {
    // TODO:
  }

  /// Calls after rendering object
  void onAfterRender(
    Scene scene,
    Camera camera,
    Geometry geometry,
    Material material,
    Group group,
  ) {
    // TODO:
  }

  static final defaultUp = Vector3(0, 1, 0);
  static final jdefaultMatrixAutoUpdate = true;

  /// This updates the position, rotation and scale with the matrix.
  void applyMatrix4(Matrix4 matrix) {
    // TODO:
  }

  Object3D applyQuaternion(Quaternion quaternion) {
    // TODO:
    return this;
  }

  void setRotationFromAxisAngle(Vector3 axis, double angle) {
    // TODO:
  }

  /// None
  // void setRotationFromEuler()

  // TODO: doc
  void setRotationFromMatrix(Matrix4 matrix) {
    // TODO:
  }

  // TODO: doc
  void setRotationFromQuaternion(Quaternion quaternion) {
    // TODO:
  }

  /// Rotate an object along an axis in object space. The axis is assumed to be normalized.
  /// axis is a normalized vector in object space.
  /// angle is in radians
  Object3D rotateOnAxis(Vector3 axis, double angle) {
    // TODO:
    return this;
  }

  /// Rotate an object along an axis in world space. The axis is assumed to be normalized. Method Assumes no rotated parent.
  /// axis	A normalized vector in object space.
  /// angle	The angle in radians.
  Object3D rotateOnWorldAxis(Vector3 axis, double angle) {
    // TODO:
    return this;
  }

  /// Rotate x by [angle] radians
  Object3D rotateX(double angle) {
    return this;
  }

  /// Rotate y by [angle] radians
  Object3D rotateY(double angle) {
    return this;
  }

  /// Rotate z by [angle] radians
  Object3D rotateZ(double angle) {
    return this;
  }

  /// Translates by distance on a normalized vector axis
  Object3D translateOnAxis(Vector3 axis, double distance) {
    return this;
  }

  /// Translates object along x axis by distance.
  Object3D translateX(double distance) {
    return this;
  }

  /// Translates object along y axis by distance.
  Object3D translateY(double distance) {
    return this;
  }

  /// Translates object along z axis by distance.
  Object3D translateZ(double distance) {
    return this;
  }

  /// Updates the vector from local space to world space.
  /// [vector] is a local vector.
  Vector3 localToWorld(Vector3 vector) {
    // TODO:
    return null;
  }

  /// Updates the vector from world space to local space.
  /// [vector] is a world vector.
  Vector3 worldToLocal(Vector3 vector) {
    // TODO:
    return null;
  }

  /// Rotates object to face point in space.
  /// [vector] is a world vector to look at.
  void lookAt(Vector3 vector) {
    // TODO:
  }

  /// Adds object as child of this object.
  Object3D add(Object3D object) {
    return this;
  }

  /// Adds all objects as child of this object.
  Object3D addAll(List<Object3D> objects) {
    return this;
  }

  /// Removes object as child of this object.
  Object3D remove(Object3D object) {
    return this;
  }

  /// Removes all [objects] from this object.
  Object3D removeAll(List<Object3D> objects) {
    return this;
  }

  /// Clears all children from this object.
  Object3D clear() {
    return this;
  }

  /// Adds object as a child of this, while maintaining the object's world transform.
  Object3D attach(Object3D object) {
    return this;
  }

  /// Searches through the object's children and returns the first with a matching key.
  Object3D getObjectByKey(Key key) {
    return null;
  }

  /// Searches through the object's children and returns the first with a matching name.
  Object3D getObjectByName(String name) {
    return null;
  }

  Vector3 getWorldPosition(Vector3 target) {
    return null;
  }

  Quaternion getWorldQuaternion(Quaternion target) {
    return null;
  }

  Vector3 getWorldScale(Vector3 target) {
    return null;
  }

  Vector3 getWorldDirection(Vector3 target) {
    return null;
  }

  void raycast(Raycaster raycaster, List<Intersection> intersects) {
    // TODO:
  }

  void traverse(void Function(Object3D object) callback) {}

  void traverseVisible(void Function(Object3D object) callback) {}

  void traverseAncestors(void Function(Object3D object) callback) {}

  /// Updates local transform.
  void updateMatrix() {}

  /// Updates global transform of the object and its children.
  void updateMatrixWorld(bool force) {}

  void updateWorldMatrix(bool updateParents, bool updateChildren) {}

  Object3D clone([bool recursive = true]) {
    return this;
  }

  Object3D copy([Object3D source, bool recursive = true]) {
    source ??= this;

    return this;
  }
}
