import gleeunit
import gleeunit/should
import string_format.{format, f, end}

pub fn main() {
  gleeunit.main()
}

pub fn format_bool_test() {
  let value = True
  let str1 =
    format("boolean is: {}")
    |> f(value)
    |> end()

  str1 |> should.equal("boolean is: True")
}

pub fn format_bitarray_test() {
  let barray = <<1:size(32), 2, 42>>
  let str1 =
    format("bitarray is: {}")
    |> f(barray)
    |> end()

  str1 |> should.equal("bitarray is: 1 2 ")
}

pub fn format_list_of_ints_test() {
  let lst = [1,2,4,8,16]
  let str1 =
    format("list is: {}")
    |> f(lst)
    |> end()

  str1 |> should.equal("list is: [1,2,4,8,16]")
}

pub fn format_list_of_floats_test() {
  let lst = [3.14, 6.28]
  let str1 =
    format("multiples of pi: {}")
    |> f(lst)
    |> end()

  str1 |> should.equal("multiples of pi: [3.14,6.28]")
}

pub fn format_single_test() {
  let name = "Joe"
  let str1 = 
      format("Hello {}.")
      |> f(name)
      |> end()

  str1 |> should.equal("Hello Joe.")
}

pub fn format_multiple_test() {
  let str1 =
    format("The location is {} and the sensor temperature is {} C.")
    |> f("living_room")
    |> f(27.5)
    |> end()

  str1 |> should.equal("The location is living_room and the sensor temperature is 27.5 C.")
}

pub fn format_with_literal_curlybraces_test() {
  let str1 =
    format("this {} contains curly braces: {{}}")
    |> f("string")
    |> end()
  
  str1 |> should.equal("this string contains curly braces: {}")
}

pub fn format_integer_test() {
  let value = 42
  let str1 = 
      format("meaning of life is {} according to literature.")
      |> f(value)
      |> end()

  str1 |> should.equal("meaning of life is 42 according to literature.")
}

pub fn format_float_test() {
  let value = 3.14159
  let str1 = 
      format("pi = {}")
      |> f(value)
      |> end()

  str1 |> should.equal("pi = 3.14159")
}

pub fn format_list_test() {
  let lst = ["a", "b", "c"]
  let str1 = 
      format("a sequence of letters: {}")
      |> f(lst)
      |> end()

  str1 |> should.equal("a sequence of letters: [a,b,c]")
}

