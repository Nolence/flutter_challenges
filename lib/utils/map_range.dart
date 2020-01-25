double mapRange(num value, num inMin, num inMax, num outMin, num outMax) {
  return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}

// double mapRange(
//   num value,
//   num leftMin,
//   num leftMax,
//   num rightMin,
//   num rightMax,
// ) {
//   // Figure out how 'wide' each range is
//   final leftSpan = leftMax - leftMin;
//   final rightSpan = rightMax - rightMin;

//   // Convert the left range into a 0-1 range (float)
//   final valueScaled = value - leftMin / leftSpan;

//   // Convert the 0-1 range into a value in the right range.
//   return rightMin + (valueScaled * rightSpan);
// }
