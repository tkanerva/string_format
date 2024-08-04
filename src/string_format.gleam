import gleam/dynamic
import gleam/float
import gleam/int
import gleam/iterator
import gleam/list
import gleam/string

fn cvt(val, dynvalue, detectfun, convertfun) {
  case detectfun(dynvalue) {
    Ok(x) -> convertfun(x)
    Error(_) -> val
  }
}

fn to_string(val) {
  let inthelper = fn(lst) {
    "[" <> string.join(list.map(lst, fn(x) { int.to_string(x) }), ",") <> "]"
  }
  let floathelper = fn(lst) {
    "[" <> string.join(list.map(lst, fn(x) { float.to_string(x) }), ",") <> "]"
  }
  let dyn = dynamic.from(val)
  "?"
  |> cvt(dyn, dynamic.int, int.to_string)
  |> cvt(dyn, dynamic.float, float.to_string)
  |> cvt(dyn, dynamic.list(of: dynamic.int), inthelper)
  |> cvt(dyn, dynamic.list(of: dynamic.float), floathelper)
  |> cvt(dyn, dynamic.list(of: dynamic.string), fn(x) {
    "[" <> string.join(x, ",") <> "]"
  })
  |> cvt(dyn, dynamic.string, fn(x) { x })
}

fn validate_fmtstr(str) {
  let graphemes = string.to_graphemes(str)
  let opencount = graphemes |> list.filter(fn(x) { x == "{" }) |> list.length
  let closedcount = graphemes |> list.filter(fn(x) { x == "}" }) |> list.length
  // TODO: validate also that there is nothing between the open close braces
  opencount == closedcount
}

// if the user wants to print "{}", they can specify "{{}}" in the fmt string
fn protect_escapes(str) {
  str |> string.replace("{{}}", "{{÷}}")
}

fn handle_escapes(str) {
  str |> string.replace("{{÷}}", "{}")
}

fn choose_seg(whole_str: String, idx: Int) {
  let tmp = whole_str |> string.split("{}")
  let res = tmp |> iterator.from_list() |> iterator.at(idx)
  case res, idx {
    Ok(x), _ -> x
    Error(_), _ -> panic as "index too big"
  }
}

/// Inserts strings, ints or floats into placeholders similar to str.format() in Python
///
/// ## Examples
///
/// ```gleam
/// format("hello {}, pi equals {}!") |> f("World") |> f(3.14) |> end()
/// // -> "hello World, pi equals 3.14!"
/// ```
///
pub fn format(fmtstr) {
  let r = validate_fmtstr(fmtstr)
  case r {
    False -> panic as "format string did not validate correctly"
    True -> {
      let protected = protect_escapes(fmtstr)
      #([], protected, 0)
    }
  }
}

pub fn f(state, val) {
  let #(pieces, fmter, idx) = state
  let fmtstr_ = choose_seg(fmter, idx)
  // first append the segment, then the value.
  let tmp = string.append(fmtstr_, to_string(val))
  #([tmp, ..pieces], fmter, idx + 1)
}

pub fn end(state) {
  let #(pieces, fmter, idx) = state
  // dump the remainder of the fmt string to the end of string.
  let tmpit = string.split(fmter, "{}") |> iterator.from_list()
  let res = iterator.at(tmpit, idx)
  let tmp = case res {
    Ok(x) -> {
      [x, ..pieces] |> list.reverse |> string.join("")
    }
    Error(_) ->
      panic as "error, more variables given than slots in the formatter."
  }
  handle_escapes(tmp)
}
