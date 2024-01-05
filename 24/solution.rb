require 'matrix'
Hailstone = Struct.new(:x, :y, :z, :vx, :vy, :vz)

def to_touch_time2(h1, h2)
  a = (h1.vx * h1.y - h1.vy * h1.x + h1.vy * h2.x - h1.vx * h2.y)
  b = h2.vy * h1.vx - h2.vx * h1.vy

  if b == 0
    nil
  else
    Rational(a, b)
  end
end

lines = File.readlines('input.txt', chomp: true)
hailstones = []
lines.each do |line|
  pos, v = line.split(' @ ').map do |triple|
    triple.split(', ').map(&:to_i)
  end
  hailstones << Hailstone.new(*pos, *v)
end

def coord_x(h1, h2)
  if h2.vx != h1.vx
    (h2.vx * h1.x - h1.vx * h2.x) / (h2.vx - h1.vx)
  elsif h1.x == h2.x
    h1.x
  end
end

# X = 7..27
# Y = 7..27

X = 200000000000000..400000000000000
Y = 200000000000000..400000000000000

count = 0

hailstones.each_with_index do |h1, i|
  hailstones.each_with_index do |h2, j|
    if i < j
      t2 = to_touch_time2(h1, h2)
      if t2 && t2 >= 0
        x2 = h2.x + t2 * h2.vx
        y2 = h2.y + t2 * h2.vy

        t1 = (h2.x + h2.vx * t2 - h1.x) / h1.vx

        if X.include?(x2) && Y.include?(y2) && t1 >= 0
          count += 1
        end
      end
    end
  end
end
p task1: count


def equation_xy(h1, h2)
  [h1.vy - h2.vy,
   h2.vx - h1.vx,
   h2.y - h1.y,
   h1.x - h2.x,
   - h2.x*h2.vy + h1.x*h1.vy - h1.y* h1.vx + h2.y * h2.vx]
end

def equation_xz(h1, h2)
  [h1.vz - h2.vz,
   h2.vx - h1.vx,
   h2.z - h1.z,
   h1.x - h2.x,
   - h2.x*h2.vz + h1.x*h1.vz - h1.z* h1.vx + h2.z * h2.vx]
end

def cramer_solutions(eq1, eq2, eq3, eq4)


  m = Matrix[eq1[0...-1], eq2[0...-1], eq3[0...-1], eq4[0...-1]]
  d = m.determinant
  d1 = Matrix[[eq1[-1], *eq1[1...-1]],
              [eq2[-1], *eq2[1...-1]],
              [eq3[-1], *eq3[1...-1]],
              [eq4[-1], *eq4[1...-1]]].determinant

  d2 = Matrix[[eq1[0], eq1[-1], *eq1[2...-1]],
              [eq2[0], eq2[-1], *eq2[2...-1]],
              [eq3[0], eq3[-1], *eq3[2...-1]],
              [eq4[0], eq4[-1], *eq4[2...-1]]].determinant
  d3 = Matrix[[*eq1[0..1], eq1[-1], eq1[3]],
              [*eq2[0..1], eq2[-1], eq2[3]],
              [*eq3[0..1], eq3[-1], eq3[3]],
              [*eq4[0..1], eq4[-1], eq4[3]]].determinant

  d4 = Matrix[[*eq1[0..2], eq1[-1]],
              [*eq2[0..2], eq2[-1]],
              [*eq3[0..2], eq3[-1]],
              [*eq4[0..2], eq4[-1]]].determinant

  x = d1 / d
  y = d2 / d
  vx = d3 / d
  vy = d4 / d

  [x, y, vx, vy]
end

eq_xy_1 = equation_xy(hailstones[0], hailstones[1])
eq_xy_2 = equation_xy(hailstones[0], hailstones[2])
eq_xy_3 = equation_xy(hailstones[0], hailstones[3])
eq_xy_4 = equation_xy(hailstones[0], hailstones[4])
x_xy, y_xy, _, _ = cramer_solutions(eq_xy_1, eq_xy_2, eq_xy_3, eq_xy_4)

eq_xz_1 = equation_xz(hailstones[0], hailstones[1])
eq_xz_2 = equation_xz(hailstones[0], hailstones[2])
eq_xz_3 = equation_xz(hailstones[0], hailstones[3])
eq_xz_4 = equation_xz(hailstones[0], hailstones[4])
x_xz, z_xz, _, _ = cramer_solutions(eq_xz_1, eq_xz_2, eq_xz_3, eq_xz_4)

if x_xy != x_xz
  fail 'solutions should be the same'
end

p x_xy+y_xy+z_xz

