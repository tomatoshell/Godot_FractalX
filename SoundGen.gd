extends AudioStreamPlayer
var sample_hz = 8000.0 # Keep the number of samples to mix low, GDScript is slow
var phase = 0.0

var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().

var pla = false
var cid = 0
var c
func mag(w):
	return sqrt(w.x*w.x - w.y*w.y);
func mult(z, w):
	return Vector2(z.x*w.x - z.y*w.y, z.x*w.y + z.y*w.x)
func div(z, w):
	var m = mag(w)
	if(m == 0):
		return mult(z,w*Vector2(1,-1))
	return mult(z,w*Vector2(1,-1))/m
func expc(z):
	return exp(z.x)*Vector2(cos(z.y), sin(z.y))
func lnc(z):
	return Vector2(log(z.length()), atan(z.y/z.x));
func ccos(z): return Vector2(cos(z.x)*cosh(z.y),-sin(z.x)*sinh(z.y))
func _fill_buffer(z):
	var increment = 1.0 / sample_hz
	var to_fill = playback.get_frames_available()
	var oldz
	while to_fill > 0:
		oldz = z
		match cid:
			0: #Mandel
				z = mult(z,z) + c
			1: #Tricorn
				z = mult(z,z)*Vector2(1,-1) + c
			2: #Exp
				z = expc(z) + c
			3: #Expel
				z = expc(z) - mult(z,z) + c
			4: #Burning ship, stable noise
				z = mult(z.abs(), z.abs()) + c
			5: #Burning mandel
				z = mult(z.abs(), z.abs()) + c
				z = mult(z,z) + c
				z = mult(z,z) + c
			6: #Long boi
				var ter = mult(z,z)
				z = c - ter - mult(z, ter) + mult(ter, ter)
			7: #Feather
				z = div(mult(z, mult(z, z)), Vector2(1,0) + z*z) + c;
			8:
				#Fern
				var ter = mult(z,z)
				var tet = mult(z,ter)
				var teq = mult(ter,ter)
				var teo = mult(teq,teq)
				z = c + z + ter + tet + teq + mult(teq, z) + mult(teq, ter) + mult(teq, tet) + teo + mult(teo, z);
			9: #SFX
				z = z*(z.x*z.x + z.y*z.y) - mult(z, c*c)
			10: #ZETA
				var on = z
				z = Vector2(1,0)
				for i in 4:
					z += expc((c - on)*log(i + 2.0))
			11: #Zergbrot
				z = mult(z,z) + c;
				z = Vector2(sin(z.x)*cosh(z.y), cos(z.x)*sinh(z.y))
			12: #Sergbrot
				z = mult(z,z) + c;
				z = Vector2(sinh(z.x)*cos(z.y), cosh(z.x)*sin(z.y))
			13: #Log
				z = lnc(z) + c;
			14: #Bbox
				if(z.x > 1):
					z.x = 2 - z.x
				elif(z.x < -1):
					z.x = -2 - z.x
				if(z.y > 1):
					z.y = 2 - z.y
				elif(z.y < -1):
					z.y = -2 - z.y
				if(mag(z) < 0.5):
					z *= 4
				elif(mag(z) < 1):
					z /= mag(z)*mag(z)
				z = -z + c;
			15:
				var zz = mult(z,z) + c
				z = mult(zz,zz) + mult(c,c) + z
			16: #AltFeather
				z = div(mult(z, mult(z, z)), Vector2(0,-1) - z*z) + c;
			17: #Chirikov
				z = Vector2(z.x + c.x*(z.y + c.y*sin(z.x)), z.y + c.y*sin(z.x))
			18: #Elex
				z = lnc(z) + expc(z) + c
			19: z = mult(lnc(z), expc(z)) + c
			20: z = div(lnc(z), expc(z)) + c
			21: z = lnc(z + c) + expc(z + c)
			22: z = mult(lnc(z + c), expc(z + c))
			23: #Gingerbread
				z = Vector2(1 - z.y + abs(z.x), z.x)
			24: #e^sin(z^2) + c
				z = mult(z,z)
				z = expc(Vector2(sin(z.x)*cosh(z.y),cos(z.x)*sinh(z.x))) + c
			25: #Collatz
				z = (z*7 + Vector2(2,0) - mult(ccos(z*PI),5*z + Vector2(2,0)))/4.0
		if abs(z.x) + abs(z.y) > 100:
			pla = false
			phase = 0.0
			break
		for i in [z*0.1667 + oldz*0.8333, z*0.3333 + oldz*0.6667, z*0.5 + oldz*0.5, z*0.6667 + oldz*0.3333, z*0.8333 + oldz*0.1667, z]:
			playback.push_frame(i.normalized())
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1
	yield(get_tree().create_timer(0.4),"timeout")
	if pla: _fill_buffer(z)

func _ready():
	playback = get_stream_playback()

func stop_sound():
	pla = false
func to_sound(z, id):
	#z = x + yi
	#x = amplitude of L channel
	#y = amplitude of R channel
	#itterate fractal func 8000 times per s(=8khz)
	#interpolate to 48khz
	cid = id
	c = z
	_fill_buffer(z)
	pla = true
	
	play()
