#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HOME"
  mkdir -p "$FUNL_STUB_BIN"
}

prepare_config() {
  cat <<RC > "$HOME/.funlrc"
animal.src: echo -e "cat\ndog\nmonkey"
animal.post: sed -e 's:^\(.*\)$:_\1_:'
weather.src: echo -e "1: sunny\n2: rainy\n3: snowy"
weather.post: sed -e 's/^[0-9]*: *\(.*\)$/\1/'
color.src: echo -e "red\ngreen\nblue"
color.post: invalid 'post' command
RC
}

@test "no arguments raises error" {
  run funl proc
  [ "$status" -ne 0 ]
  [ -z "$output" ]
}

@test "no config raises error" {
  run funl proc "slct" "{animal}" "and" "{weather}"
  [ "$status" -ne 0 ]
  [ "$output" == "funl: config not found" ]
}

@test "no placeholders passes through arguments" {
  stub_command 'slct'

  run funl proc "slct" "monkey" "and" "snowy"
  [ "$status" -eq 0 ]
  [ "$output" == "slct: monkey and snowy" ]

  run funl proc "slct" "-m" '"monkey [snowy]"'
  [ "$status" -eq 0 ]
  [ "$output" == 'slct: -m "monkey [snowy]"' ]
}

@test "processes 1 placeholder" {
  prepare_config
  stub_command 'slct'
  stub_peco 1

  run funl proc "slct" "{animal}" "is animal"
  [ "$status" -eq 0 ]
  [ "$output" == "slct: _cat_ is animal" ]
}

@test "processes 2 placeholders" {
  prepare_config
  stub_command 'slct'
  stub_peco 2

  run funl proc "slct" "{animal}" "and" "{weather}"
  [ "$status" -eq 0 ]
  [ "$output" == "slct: _dog_ and rainy" ]
}

@test "processes 2 placeholders in one argument" {
  prepare_config
  stub_command 'slct'
  stub_peco 2

  run funl proc "slct" "{animal}, {animal}" "and" "{animal}"
  [ "$status" -eq 0 ]
  [ "$output" == "slct: _dog_, _dog_ and _dog_" ]
}

@test "fills same placeholders with same values at once" {
  cmd_path="$FUNL_STUB_BIN/funl_post"
  cat <<SH > "$cmd_path"
#!/usr/bin/env bash
mv "\$HOME/.funlrc" "\$HOME/.funlrc.orig"
cat <&0
SH
  chmod +x "$cmd_path"

  cat <<RC > "$HOME/.funlrc"
animal.src: echo -e "cat\ndog\nmonkey"
animal.post: funl_post
RC
  stub_command 'slct'
  stub_peco 3

  run funl proc "slct" "{animal}" "and" "{animal}"
  echo "$status: $output"
  [ "$status" -eq 0 ]
  [ "$output" == "slct: monkey and monkey" ]
}

@test "no placeholder definition" {
  prepare_config
  stub_command 'slct'
  stub_peco 3

  run funl proc "slct" "{weather}" "and" "{movie}"
  [ "$status" -ne 0 ]
  [ "$output" == "funl: 'movie.src' definition not found" ]
}

@test "error occurring in post-process" {
  prepare_config
  stub_command 'slct'
  stub_peco 1

  run funl proc "slct" "{color}"
  [ "$status" -ne 0 ]
  [ "$output" == "funl: error occured in post-process 'color.post'" ]
}
