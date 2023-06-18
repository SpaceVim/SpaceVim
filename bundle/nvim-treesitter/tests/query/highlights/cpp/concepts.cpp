
template <class T, class U>
concept Derived = std::is_base_of<U, T>::value;
//  ^ keyword
//       ^ type.definition

template<typename T>
concept Hashable = requires(T a) {
//                   ^ keyword
//                            ^ parameter
//                          ^ type
    { std::hash<T>{}(a) } -> std::convertible_to<std::size_t>;
 typename CommonType<T, U>; // CommonType<T, U> is valid and names a type
    { CommonType<T, U>{std::forward<T>(t)} }; 
    { CommonType<T, U>{std::forward<U>(u)} }; 
};


template<typename T>
    requires requires (T x) { x + x; } // ad-hoc constraint, note keyword used twice
//                 ^ keyword
T add(T a, T b) { return a + b; }
