import 'package:challenges/shared/flutter_three/core/intersection.dart';
import 'package:challenges/shared/flutter_three/core/object_3D.dart';
import 'package:flutter/painting.dart' show Offset;
import 'package:vector_math/vector_math.dart' show Ray, Vector3;

import 'camera.dart';

class Raycaster {
  Raycaster();

  /// The Ray used for the raycasting.
  Ray ray;

  /// The near factor of the raycaster. This value indicates which objects can be discarded based on the
  /// distance. This value shouldn't be negative and should be smaller than the far property.
  int near;

  /// The far factor of the raycaster. This value indicates which objects can be discarded based on the
  /// distance. This value shouldn't be negative and should be larger than the near property.
  int far;

  /// The camera to use when raycasting against view-dependent objects such as billboarded objects like Sprites. This field
  /// can be set manually or is set when calling "setFromCamera".
  Camera camera;

  /// The precision factor of the raycaster when intersecting Line objects.
  int linePrecision;

  /// Updates the ray with a new origin and direction.
  /// [origin] The origin vector where the ray casts from.
  /// [direction] The normalized direction vector that gives direction to the ray.
  void set(Vector3 origin, Vector3 direction) {}

  /// pdates the ray with a new origin and direction.
  /// param coords 2D coordinates of the mouse, in normalized device coordinates (NDC)---X and Y components should be between -1 and 1.
  /// param camera camera from which the ray should originate
  void setFromCamera(Offset coords, Camera camera) {}

  /// Checks all intersection between the ray and the object with or without the descendants. Intersections are returned sorted by distance, closest first.
  /// [object] The object to check for intersection with the ray.
  /// [recursive] If true, it also checks all descendants. Otherwise it only checks intersecton with the object. Default is false.
  /// [optionalTarget] (optional) target to set the result. Otherwise a new Array is instantiated. If set, you must clear this array prior to each call (i.e., array.length = 0;).
  Intersection intersectObject(
    Object3D object, [
    bool recursive,
    List<Intersection> optionalTarget,
  ]) {
    return null;
  }

  /// Checks all intersection between the ray and the objects with or without the descendants. Intersections are returned sorted by distance, closest first. Intersections are of the same form as those returned by .intersectObject.
  /// [objects] The objects to check for intersection with the ray.
  /// [recursive] If true, it also checks all descendants of the objects. Otherwise it only checks intersecton with the objects. Default is false.
  /// [optionalTarget] (optional) target to set the result. Otherwise a new Array is instantiated. If set, you must clear this array prior to each call (i.e., array.length = 0;).
  Intersection intersectObjects(
    List<Object3D> objects, [
    bool recursive,
    List<Intersection> optionalTarget,
  ]) {
    return null;
  }
}
