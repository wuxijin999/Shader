Shader "Wizard/Wizard_UIMask" {

	Properties{
		_MainTex("Base", 2D) = "white"
		_Rect("Rect" , Vector) = (1,1,1,1)
	}

		SubShader{

			Tags
			{
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
			}

			Pass{

				Cull Off
				Lighting Off
				ZWrite Off

				Fog{ Mode Off}
				ColorMask RGB
				Blend SrcAlpha OneMinusSrcAlpha

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#define iResolution _ScreenParams  
				#define gl_FragCoord ((IN.scrPos.xy/IN.scrPos.w)*_ScreenParams.xy) 
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _Rect;

				struct appdata_t
				{
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
					float4 color : COLOR;
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
					half2 texcoord : TEXCOORD0;
					float4 scrPos:TEXCOORD1;
					fixed4 color : COLOR;
				};

				v2f vert(appdata_t v)
				{
					v2f o;
					o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
					o.texcoord = v.texcoord;
					o.scrPos = ComputeScreenPos(v.vertex);
					o.color = v.color;
					return o;
				}

				float4 frag(v2f i) : COLOR
				{
					float2 v2 = i.scrPos.xy /_ScreenParams.xy;

					if (v2.x > _Rect.x / 1920 - _Rect.z*0.5 / 1920
						&& v2.x<_Rect.x / 1920 + _Rect.z*0.5 / 1920
						&& v2.y>_Rect.y / 1080 - _Rect.w*0.5 / 1080
						&& v2.y < _Rect.y / 1080 + _Rect.w*0.5 / 1080) {
						return tex2D(_MainTex, i.texcoord) * i.color;
					}
					else {
						return float4(1.0, 1.0, 1.0, 0.0);
					}

				}

				ENDCG
			}
	}
}