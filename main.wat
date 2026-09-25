(module
  (import "env" "random_u32"
    (func $random_u32 (result i32))
  )
  (start $init_chars)
  (memory (export "memory") 1)
  (func $random_bool (result i32)
    call $random_u32
    i32.const 2
    i32.rem_u)
  (func $random_char (result i32)
    call $random_u32
    i32.const 88
    i32.rem_u
    call $calc_offset
    i32.load)
  (func $random_bef (param i32) (result i32)
    call $random_u32
    local.get 0
    i32.const 1
    i32.add
    i32.rem_u)
  (func $calc_offset (param i32) (result i32)
    (local $count i32)
    (local $index i32)
    i32.const 0
    local.set $count
    i32.const 0
    local.set $index
    (block $done
    (loop $my_loop
      local.get $count
      local.get 0
      i32.ge_u
      br_if $done
      local.get $count
      i32.const 1
      i32.add
      local.set $count
      local.get $index
      i32.const 4
      i32.add
      local.set $index
      (br $my_loop)
    )
      )
    local.get $index
  )
  (func $init_chars 
    (local $count i32)
    (local $index i32)
    i32.const 33
    local.set $count
    i32.const 0
    local.set $index
    (block $done
    (loop $my_loop
      local.get $count
      i32.const 58
      i32.ge_u
      br_if $done
      local.get $index
      local.get $count
      i32.store
      local.get $count
      i32.const 1
      i32.add
      local.set $count
      local.get $index
      i32.const 4
      i32.add
      local.set $index
      (br $my_loop)
    )
      )
    i32.const 63
    local.set $count
    (block $done
    (loop $my_loop
      local.get $count
      i32.const 126
      i32.ge_u
      br_if $done
      local.get $index
      local.get $count
      i32.store
      local.get $count
      i32.const 1
      i32.add
      local.set $count
      local.get $index
      i32.const 4
      i32.add
      local.set $index
      (br $my_loop)
    )
      )
  )
  (func $to_upper (param i32) (result i32)
    local.get 0
    i32.const 32
    i32.sub)
  (func $to_lower (param i32) (result i32)
    local.get 0
    i32.const 32
    i32.add)
  (func $is_upper (param i32) (result i32)
    local.get 0
    i32.const 65
    i32.ge_u
    local.get 0
    i32.const 90
    i32.le_u
    i32.and)
  (func $is_lower (param i32) (result i32)
    local.get 0
    i32.const 97
    i32.ge_u
    local.get 0
    i32.const 122
    i32.le_u
    i32.and)
  (func $toggle_case (param i32) (result i32)
    local.get 0
    call $is_upper
    if  (result i32)
      local.get 0
      call $to_lower
    else
      local.get 0
      call $is_lower
      if (result i32)
        local.get 0
        call $to_upper
      else
        local.get 0
      end
    end
    )
  (func $is_leet (export "is_leet") (param i32) (result i32)
    local.get 0
    i32.const 97
    i32.ge_u

    local.get 0
    i32.const 122
    i32.le_u

    i32.and

    if
      local.get 0
      i32.const 32
      i32.sub
      local.set 0
    end

    local.get 0
    i32.const 65
    i32.eq
    local.get 0
    i32.const 66
    i32.eq
    i32.or
    local.get 0
    i32.const 67
    i32.eq
    i32.or
    local.get 0
    i32.const 69
    i32.eq
    i32.or
    local.get 0
    i32.const 71
    i32.eq
    i32.or
    local.get 0
    i32.const 72
    i32.eq
    i32.or
    local.get 0
    i32.const 73
    i32.eq
    i32.or
    local.get 0
    i32.const 76
    i32.eq
    i32.or
    local.get 0
    i32.const 79
    i32.eq
    i32.or
    local.get 0
    i32.const 83
    i32.eq
    i32.or
    local.get 0
    i32.const 84
    i32.eq
    i32.or
    local.get 0
    i32.const 88
    i32.eq
    i32.or
    local.get 0
    i32.const 90
    i32.eq
    i32.or
    local.get 0
    i32.const 32
    i32.eq
    i32.or)
  (func $to_leet (param i32) (result i32)
    (local $upper i32)
    local.get 0
    local.set $upper

    local.get 0
    i32.const 97
    i32.ge_u

    local.get 0
    i32.const 122
    i32.le_u

    i32.and

    if
      local.get 0
      i32.const 32
      i32.sub
      local.set $upper
    end
    
    local.get $upper
    i32.const 65
    i32.eq
    if (result i32)
      i32.const 52
    else
      local.get $upper
      i32.const 66
      i32.eq
      if (result i32)
        i32.const 56
      else
        local.get $upper
        i32.const 67
        i32.eq
        if (result i32)
          i32.const 40
        else
          local.get $upper
          i32.const 69
          i32.eq
          if (result i32)
            i32.const 51
          else
            local.get $upper
            i32.const 71
            i32.eq
            if (result i32)
              i32.const 54
            else
              local.get $upper
              i32.const 72
              i32.eq
              if (result i32)
                i32.const 35
              else
                local.get $upper
                i32.const 73
                i32.eq
                if (result i32)
                 i32.const 49
                else
                  local.get $upper
                  i32.const 76
                  i32.eq
                  if (result i32)
                    i32.const 124
                  else
                    local.get $upper
                    i32.const 79
                    i32.eq
                    if (result i32)
                      i32.const 48
                    else
                      local.get $upper
                      i32.const 83
                      i32.eq
                      if (result i32)
                        i32.const 36
                      else
                        local.get $upper
                        i32.const 84
                        i32.eq
                        if (result i32)
                          i32.const 55
                        else
                          local.get $upper
                          i32.const 88
                          i32.eq
                          if (result i32)
                            i32.const 37
                          else
                            local.get $upper
                            i32.const 90
                            i32.eq
                            if (result i32)
                              i32.const 50
                            else
                              local.get $upper
                              i32.const 32
                              i32.eq
                              if (result i32)
                                i32.const 95
                              else
                                local.get 0
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  )
  (func (export "pwd_gen") (param i32 i32 i32) (result i32)
    (local $missing i32)
    (local $i i32)
    (local $before i32)
    (local $after i32)
    (local $index_i i32)
    (local $out_len i32)
    (local $char i32)
    (local $out_start i32)
    (local $has_upper i32)
    (local $has_lower i32)
    (local $has_number i32)
    (local $has_symbol i32)
    local.get 2
    local.set $out_start
    i32.const 0
    local.set $out_len
    i32.const 0
    local.set $i
    local.get 1
    i32.const 11
    i32.le_u
    if
      i32.const 12
      local.get 1
      i32.sub
      local.set $missing
      
      local.get $missing
      call $random_bef
      local.set $before
      
      local.get $missing
      local.get $before
      i32.sub
      local.set $after
    
    (block $done
    (loop $my_loop
      local.get $i
      local.get $before
      i32.ge_u
      br_if $done
      local.get $i
      i32.const 1
      i32.add
      local.set $i
      local.get 2
      call $random_char
      i32.store8
      local.get 2
      i32.const 1
      i32.add
      local.set 2
      local.get $out_len
      i32.const 1
      i32.add
      local.set $out_len
      (br $my_loop)
    )
      )
    end

    i32.const 0
    local.set $i

    (block $done
    (loop $my_loop
      local.get $index_i
      local.get 1
      i32.ge_u
      br_if $done

      ;; cargar el char
      local.get 0
      local.get $index_i
      i32.add
      i32.load8_u
      local.set $char
      ;; ver si es leet
      local.get $char
      i32.const 32
      i32.eq
      if
       local.get $char
       call $to_leet
       local.set $char
      else
       local.get $char
       call $is_leet
       if 
        call $random_bool
        if
          local.get $char
          call $to_leet
          local.set $char
        else
          call $random_bool
          if
            local.get $char
            call $toggle_case
            local.set $char
          end
        end
       else
        call $random_bool
        if 
          local.get $char
          call $toggle_case
          local.set $char
        end
       end
      end

      local.get 2
      local.get $char
      i32.store8
      
      local.get $index_i
      i32.const 1
      i32.add
      local.set $index_i
      
      local.get 2
      i32.const 1
      i32.add
      local.set 2
      
      local.get $out_len
      i32.const 1
      i32.add
      local.set $out_len
      
      (br $my_loop)
    )
    )
    
    local.get 1
    i32.const 11
    i32.le_u
    if
      i32.const 0
      local.set $i
    (block $done
    (loop $my_loop
      local.get $i
      local.get $after
      i32.ge_u
      br_if $done
      local.get $i
      i32.const 1
      i32.add
      local.set $i
      local.get 2
      call $random_char
      i32.store8
      local.get 2
      i32.const 1
      i32.add
      local.set 2
      local.get $out_len
      i32.const 1
      i32.add
      local.set $out_len
      (br $my_loop)
    )
      )
    end
    
    i32.const 0
    local.set $i

    (block $check_done
    (loop $check_loop

    local.get $i
    local.get $out_len
    i32.ge_u
    br_if $check_done

    ;; char = output[i]
    local.get $out_start
    local.get $i
    i32.add
    i32.load8_u
    local.set $char

    ;; uppercase
    local.get $char
    call $is_upper
    if
      i32.const 1
      local.set $has_upper
    end

    ;; lowercase
    local.get $char
    call $is_lower
    if
      i32.const 1
      local.set $has_lower
    end

    ;; number: '0' <= char <= '9'
    local.get $char
    i32.const 48
    i32.ge_u

    local.get $char
    i32.const 57
    i32.le_u

    i32.and

    if
      i32.const 1
      local.set $has_number
    end

    ;; símbolo = no letra y no número
    local.get $char
    call $is_upper

    local.get $char
    call $is_lower
    i32.or

    local.get $char
    i32.const 48
    i32.ge_u

    local.get $char
    i32.const 57
    i32.le_u

    i32.and

    i32.or
    i32.eqz

    if
      i32.const 1
      local.set $has_symbol
    end

    local.get $i
    i32.const 1
    i32.add
    local.set $i

    br $check_loop
    )
    )

    ;; Falta uppercase
    local.get $has_upper
    i32.eqz
    if
      local.get $out_start
      local.get $out_len
      i32.add

      call $random_upper
      i32.store8

      local.get $out_len
      i32.const 1
      i32.add
      local.set $out_len
    end

    local.get $has_lower
    i32.eqz
    if
      local.get $out_start
      local.get $out_len
      i32.add

      call $random_lower
      i32.store8

      local.get $out_len
      i32.const 1
      i32.add
      local.set $out_len
    end

    local.get $has_number
    i32.eqz
    if
      local.get $out_start
      local.get $out_len
      i32.add

      call $random_number
      i32.store8

      local.get $out_len
      i32.const 1
      i32.add
      local.set $out_len
    end

    local.get $has_symbol
    i32.eqz
    if
      local.get $out_start
      local.get $out_len
      i32.add

      call $random_symbol
      i32.store8

      local.get $out_len
      i32.const 1
      i32.add
      local.set $out_len
    end

    local.get $out_len
  )
  (func $random_upper (result i32)
  call $random_u32
  i32.const 26
  i32.rem_u
  i32.const 65
  i32.add
)

(func $random_lower (result i32)
  call $random_u32
  i32.const 26
  i32.rem_u
  i32.const 97
  i32.add
)

(func $random_number (result i32)
  call $random_u32
  i32.const 10
  i32.rem_u
  i32.const 48
  i32.add
)

(func $random_symbol (result i32)
  ;; ASCII 33-47: ! " # $ % & ' ( ) * + , - . /
  call $random_u32
  i32.const 15
  i32.rem_u
  i32.const 33
  i32.add
)
)
