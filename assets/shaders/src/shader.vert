#version 460

layout(location = 0) in vec3 vPosition;
layout(location = 1) in vec3 vNormal;
layout(location = 2) in vec3 vColor;
layout(location = 3) in vec2 vTexCoord;

layout(location = 0) out vec3 fragPos;
layout(location = 1) out vec3 fragColor;
layout(location = 2) out vec2 texCoord;
layout(location = 3) out flat vec4 objectColor;
layout(location = 4) out vec3 normal;

layout(set = 0, binding = 0) uniform CameraBuffer {
	mat4 view;
	mat4 proj;
	mat4 viewproj;
	vec4 position;
} cam;

struct ObjectData{
	mat4 model;
	vec4 color;
};

layout(std140, set = 1, binding = 0) readonly buffer ObjectBuffer{
	ObjectData objects[];
} objectBuffer;

layout(push_constant) uniform constants {
	ivec4 data;
	mat4 render_matrix;
} pc;

void main()
{
	mat4 modelMat = objectBuffer.objects[gl_BaseInstance].model;
	mat4 transformMat = cam.viewproj * modelMat;

	gl_Position = transformMat * vec4(vPosition, 1.0f);

	fragPos = vec3(modelMat * vec4(vPosition, 1.0f));
	fragColor = vColor;
	texCoord = vTexCoord;
	objectColor = objectBuffer.objects[gl_BaseInstance].color;
	normal = mat3(transpose(inverse(modelMat))) * vNormal;
}
