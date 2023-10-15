typedef Mapper<T, S> = S Function(T);

int unsignedShift(int value, int by) {
  return (value & 0xFFFFFFFF) >> by;
}
