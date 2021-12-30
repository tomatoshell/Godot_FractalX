shader_type canvas_item;

uniform vec2 ofs = vec2(-0.,0.);
uniform float zoom = 1.;
uniform int type = 0;
uniform int visual = 0;
uniform bool cinversion = false;
uniform vec2 cc;
const float TAU = 6.283185307;
uniform int iter = 500;
const float PI = 3.1415926535897;

vec2 mult(vec2 z, vec2 w){
	return vec2(z.x*w.x - z.y*w.y, z.x*w.y + z.y*w.x);
}

float mag(vec2 z){
	return sqrt(abs(z.x*z.x - z.y*z.y));
}

vec2 div(vec2 a, vec2 b){
	float m = length(b);
	if(m == 0.){return mult(a, b*vec2(1.,-1.));}
	return mult(a, b*vec2(1.,-1.))/m;
}


vec2 expc(vec2 z){
	return exp(z.x)*vec2(cos(z.y), sin(z.y));
}

vec2 ln(vec2 z){
	return vec2(log(length(z)), atan(z.y/z.x));
}

vec2 ccos(vec2 z){
	return vec2(cos(z.x)*cosh(z.y), -sin(z.x)*sinh(z.y));
}
vec2 csin(vec2 z){
	return vec2(sin(z.x)*cosh(z.y), cos(z.x)*sinh(z.y));
}
vec2 cpow(vec2 z, vec2 w){
	return expc(mult(w, ln(z)));
}

vec3 rcol(int count){
	return vec3(abs(sin(float(count))/3.14156), abs(cos(float(count/3))/3.14156), abs(cos(tan(float(count/7))))/3.14156);
}

void fragment(){
	vec2 uv = (UV - 0.5)*4./zoom + ofs;
	
	if(cinversion){uv = normalize(uv)*(0.5/length(uv));}
	
	int count = 0;
	vec2 c = cc;
	if(length(c) == 0.){c = vec2(uv.x, uv.y);}
	vec2 hmm = vec2(uv.x, uv.y);
	vec2 mem = vec2(0.);
	
	//hmm = vec2(0., 0.);
	
	float picko = 1.;
	for(int i = 0; i < iter; i++){
		count += 1;
		if(type == 0){
			//Mandel
			hmm = mult(hmm, hmm) + c;
		}else if(type == 1){
			//Tricorn
			hmm = mult(hmm, hmm)*vec2(1.,-1.) + c;
			if(mag(hmm) > 2.){break;}
		}else if(type == 2){
			//Exp
			hmm = expc(hmm) + c;
		}else if(type == 3){
			//Expely
			hmm = expc(hmm) - mult(hmm, hmm) + c;
			if(mag(hmm) > 3.142){break;}
		}else if(type == 4){
			//Burning ship
			hmm = mult(abs(hmm), abs(hmm)) + c;
		}else if(type == 5){
			//Burning mandel
			hmm = mult(abs(hmm), abs(hmm)) + c;
			hmm = mult(hmm, hmm) + c;
			hmm = mult(hmm, hmm) + c;
			if(mag(hmm) > 2.){break;}
		}else if(type == 6){
			//Long boi
			vec2 ter = mult(hmm,hmm);
			hmm = c - ter - mult(hmm, ter) + mult(ter,ter);
			if(mag(hmm) > 2.){break;}
		}else if(type == 7){
			//Feather
			hmm = div(mult(hmm, mult(hmm, hmm)), vec2(1., 0.) + hmm*hmm) + c;
			if(mag(hmm) > 2.){break;}
		}else if(type == 8){
			//Mandel ferns of power series
			vec2 ter = mult(hmm, hmm);
			vec2 tet = mult(ter, hmm);
			vec2 teq = mult(ter, ter);
			vec2 teo = mult(teq, teq);
			hmm = c + hmm + ter + tet + teq + mult(teq, hmm) + mult(teq, ter) + mult(teq, tet) + teo + mult(teo, hmm);
			if(mag(hmm) > 2.){break;}
		}else if(type == 9){
			//SFX
			hmm = hmm*(hmm.x*hmm.x + hmm.y*hmm.y) - mult(hmm, c*c);
			if(mag(hmm) > 2.){break;}
		}else if(type == 10){
			//ZETA
			vec2 on = hmm;
			hmm = vec2(1., 0.);
			for(int j = 0; j < 4; j++){
				hmm += expc((c - on)*log(float(j) + 2.));
			}
		}else if(type == 11){
			//Zerg
			hmm = mult(hmm, hmm) + c;
			hmm = csin(hmm);
			if(mag(hmm) > 99999.){break;}
		}else if(type == 12){
			//alt-Zerg
			hmm = mult(hmm, hmm) + c;
			hmm = vec2(sinh(hmm.x)*cos(hmm.y), cosh(hmm.x)*sin(hmm.y));
			if(mag(hmm) > 99999.){break;}
		}else if(type == 13){
			hmm = ln(hmm) + c;
			if(abs(hmm.x) < 0.01){break;}
		}else if(type == 14){
			if(hmm.x > 1.){hmm.x = 2. - hmm.x;}
			else if(hmm.x < -1.){hmm.x = -2. - hmm.x;}
			if(hmm.y > 1.){hmm.y = 2. - hmm.y;}
			else if(hmm.y < -1.){hmm.y = -2. - hmm.y;}
			if(mag(hmm) < .5){hmm *= 4.;}
			else if(mag(hmm) < 1.){hmm /= mag(hmm)*mag(hmm);}
			hmm = -hmm + c;
			if(max(abs(hmm.x), abs(hmm.y)) > 4.){break;}
		}else if(type == 15){
			//Meta
			vec2 nt = mult(hmm, hmm) + c;
			hmm = mult(nt, nt) + mult(c,c) + hmm;
			if(mag(hmm) > 2.){break;}
		}else if(type == 16){
			//Feather 2
			hmm = div(mult(hmm, mult(hmm, hmm)), vec2(0., -1.) - hmm*hmm) + c;
			if(mag(hmm) > 2.){break;}
		}else if(type == 17){
			//Chirikov
			hmm = vec2(hmm.x + c.x*(hmm.y + c.y*sin(hmm.x)), hmm.y + c.y*sin(hmm.x));
			if(mag(hmm) > 6.29){break;}
		}else if(type == 18){
			//Elex
			vec2 ol = hmm;
			hmm = ln(hmm + c) + expc(hmm) + c;
		}else if(type == 19){
			//Elex
			hmm = mult(ln(hmm), expc(hmm)) + c;
		}else if(type == 20){
			//Elex
			hmm = div(ln(hmm), expc(hmm)) + c;
		}else if(type == 21){
			//Elex
			hmm = ln(hmm + c) + expc(hmm + c);
		}else if(type == 22){
			//Elex
			hmm = mult(ln(hmm + c), expc(hmm + c));
		}else if(type == 23){
			//Ginger
			hmm = vec2(1. - hmm.y + abs(hmm.x), hmm.x);
		}else if(type == 24){
			//e^sin(z^2) + c
			hmm = mult(hmm, hmm);
			hmm = expc(vec2(sin(hmm.x)*cosh(hmm.y), cos(hmm.x)*sinh(hmm.y))) + c;
		}else if(type == 25){
			//3x + 1
			hmm = (hmm*7. + vec2(2.,0.) - mult(ccos(hmm*PI) + csin(c*PI), (5.*hmm + vec2(2., 0.))))/4.;
			if(mag(hmm) > 64.){break;}
		}else if(type == 26){
			hmm = cpow(hmm, vec2(1.5, 0.)) + c;
		}else if(type == 27){
			//Nova fractal but not coz not sure how 2 get that 2 work
			hmm = hmm - div(mult(hmm, mult(hmm,hmm)) + c, 3.*mult(hmm, hmm)) + c;
		}else if(type == 28){
			//Oceanic atractor
			float olx = hmm.x;
			hmm.x = hmm.y - c.x*(1. - 0.05*hmm.y*hmm.y)*hmm.y + (c.y*hmm.x + (2.*(1. - c.y)*hmm.x*hmm.x)/(1. + hmm.x*hmm.x));
			hmm.y = (c.y*hmm.x + (2.*(1. - c.y)*hmm.x*hmm.x)/(1. + hmm.x*hmm.x)) - olx;
		}else if(type == 29){
			//Smthn
			hmm = (div(hmm*hmm, mult(hmm,hmm)) + c);
		}else if(type == 30){
			//fold
			hmm = vec2(hmm.y, hmm.x);
			c = vec2(c.y, c.x);
			hmm = mult(hmm, hmm) + c;
		}else if(type == 31){
			//fold inv
			hmm = vec2(hmm.y, hmm.x);
			c = vec2(c.y, c.x);
			hmm = mult(hmm, hmm) + div(hmm,c);
		}else if(type == 32){
			//Inv
			hmm = mult(hmm, hmm) + div(hmm,c);
			c = hmm - c;
		}
		
		float tr_o = min(picko, min(abs(hmm.y), abs(hmm.x))); // Orthogonal
		float tr_d = min(picko, abs(hmm.x*hmm.x - hmm.y*hmm.y)); //Diagonal
		float tr_c = min(picko, abs(length(hmm) - 0.333)); //Circles
		float tr_cc = min(picko, abs(length(hmm) - 0.5)); //Circles
		
		picko = min(tr_c, tr_cc)*0.5 + min(tr_o,tr_d)*0.5;
	}
	float ag = float(count)/float(iter);
	float angle = (acos(hmm.x/length(hmm))*sign(hmm.y)*0.5 + 0.5)/3.;
	if(visual == 0 && count != iter - 1){COLOR.rgb *= float(angle > -1.);}
	//Picko
	if(visual%2 == 1){COLOR.rgb *= pow(1. - picko, 64.);}
	else{COLOR.rgb *= ag;}
	
	if(count == iter){if((visual/2)%2 == 1){COLOR.rgb *= vec3(sin(angle*TAU), sin(angle*TAU + TAU*0.333), sin(angle*TAU + TAU*0.667))*0.5 + 0.5;}}
}

