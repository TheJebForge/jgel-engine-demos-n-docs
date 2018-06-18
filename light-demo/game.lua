jgel.initWindow(1400,800,"Test",true)

local vs = [[
#version 120
attribute vec3 position;
attribute vec2 texCoord;
attribute vec3 normal;
uniform mat4 transform;
varying vec3 normal0;
varying vec3 pos0;
void main(){
	gl_Position = transform * vec4(position,1.0);
	normal0 = normal;
	pos0 = position;
}
]]

local fs = [[
#version 120
uniform vec4 color;
varying vec3 normal0;
varying vec3 pos0;
uniform mat4 transform;
uniform vec3 light;
uniform vec3 position;
void main(){ 
	vec3 verPos = pos0+position;
	vec3 lightDir = normalize(light-verPos);
	vec3 normal = (transform * vec4(normal0,0)).xyz;
	float distance = sqrt( pow(verPos.x,2) + pow(verPos.y,2) + pow(verPos.z,2) );
	gl_FragColor = color * dot(normal,lightDir);
}
]]

local cam = jgel.createCamera({0,0,-3},90,0.1,1000)
local model = jgel.createMeshObject({0,0,3},{"ball.obj"},{1,1,0,0})
model.createCustomShader(vs,fs)

local model2 = jgel.createMeshObject({-4,3,3},{"ball.obj"},{1,1,0,0})
model2.createCustomShader(vs,fs)

local model3 = jgel.createMeshObject({4,-3,3},{"ball.obj"},{1,1,0,0})
model3.createCustomShader(vs,fs)

local light = {type="float",count=3,0,0,0}

model.uniforms.light = light
model.uniforms.position = {type="float",count=3,0,0,3}

model2.uniforms.light = light
model2.uniforms.position = {type="float",count=3,4,3,3}

model3.uniforms.light = light
model3.uniforms.position = {type="float",count=3,-4,-3,3}

local rotx,roty = 0,0
while not jgel.isDone() do
	local x,y = jgel.mouse.getMouseInput()
	local mx,my = jgel.mouse.getMousePos()
	rotx,roty = rotx+x/200,roty-y/200
	jgel.displayClear(0,0,0,0)
	light[1],light[2] = (700-mx)/(700/6)*-1,(400-my)/(400/6)
	model.draw()
	model2.draw()
	model3.draw()
	local g = jgel.keyboard.getKeyEvent()
	print(type(g))
	jgel.pullEvent()
end
