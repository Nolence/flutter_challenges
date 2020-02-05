import 'dart:ui';

import 'package:challenges/shared/flutter_three/core/material.dart';
import 'package:challenges/shared/flutter_three/core/object_3D.dart';
import 'package:challenges/shared/flutter_three/scenes/fog.dart';
import 'package:challenges/shared/flutter_three/textures/texture.dart';
import 'package:vector_math/vector_math.dart';

/// Scenes allow you to set up what and where is to be rendered by three.js. This is where you place objects, lights and cameras.
class Scene extends Object3D {
  Scene(
    Vector3 position,
    double rotation,
    Quaternion quaternion,
    Vector3 scale,
    Matrix4 modelViewMatrix,
    Matrix3 normalMatrix,
  ) : super(
          position,
          rotation,
          quaternion,
          scale,
          modelViewMatrix,
          normalMatrix,
        );

  /// A fog instance defining the type of fog that affects everything rendered in the scene. Default is null.
  Fog fog;

  /// If not null, it will force everything in the scene to be rendered with that material. Default is null.
  Material overrideMaterial;

  bool autoUpdate;

  ///Both backgroundTexture and backgroundColor cannot be set
  Color backgroundColor;

  ///Both backgroundTexture and backgroundColor cannot be set
  Texture backgroundTexture;

  Texture environment;

  final isScene = true;

  String toJson([dynamic meta]) {
    return null;
  }

  void dispose() {}
}
