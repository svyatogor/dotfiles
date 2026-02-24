;; defsrc is still necessary
(defcfg
  process-unmapped-keys yes
)

(defsrc
  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10   f11   f12
  caps a s d f h j k l ;
  spc
  fn
)
(defvar
  tap-time 150
  hold-time 200
)

(defalias
  escctrl (tap-hold 100 100 esc lctl)
  
  ;; Левая рука
  a (tap-hold-release $tap-time $hold-time a lsft)
  s (tap-hold-release $tap-time $hold-time s lmet)
  d (tap-hold-release $tap-time $hold-time d lalt)
  f (tap-hold-release $tap-time $hold-time f lctl)

  ;; Правая рука
  j (tap-hold-release $tap-time $hold-time j rctl)
  k (tap-hold-release $tap-time $hold-time k ralt)
  l (tap-hold-release $tap-time $hold-time l rmet)
  ; (tap-hold-release $tap-time $hold-time ; rsft)

  fnl (tap-hold 200 200 fn (layer-toggle fn))
  spc (tap-hold $tap-time $hold-time spc (layer-toggle nav))
)

(deflayer base
  brdn  brup  _    _    _    _   prev  pp  next  mute  vold  volu
  @escctrl @a @s @d @f _ @j @k @l @;
  @spc
  @fnl
)

(deflayer nav
  _ _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ lft down up rght _
  spc
  fn
)

(deflayer fn
  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10   f11   f12
  @escctrl _ _ _ _ _ _ _ _ _
  _
  fn
)
