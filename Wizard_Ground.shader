Shader "Wizard/Ground_Tile" {
	Properties{
		_MainTex("Base", 2D) = "white"
		_Mile("Mile",Float) = 1
	}
		SubShader{
		Pass{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
				sampler2D _MainTex;
				float _Mile;
				struct v2f {
					float4  pos : SV_POSITION;
					float2  uv : TEXCOORD0;
				};
				v2f vert(appdata_base v)
				{
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
					o.uv = mul(_Object2World,v.vertex).xz;
				//	o.uv = v.vertex.xz;
					return o;
				}
		float4 frag(v2f i) : COLOR
			{
				float2 uv = float2(fmod(abs(i.uv.x + 10000 * _Mile),_Mile) / _Mile,fmod(abs(i.uv.y + 10000 * _Mile),_Mile) / _Mile);
				float4 texCol = tex2D(_MainTex, uv);
				return texCol;
			}
		ENDCG
		}
	}
}


