Shader "Wizard/Ground_Tile" {
	Properties{
		_MainTex("Base", 2D) = "white"
		_MaskTex("Mask",2D) = "white"
	}
		SubShader{

		LOD 100
		Tags{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
	}

		Pass{

		Cull Off
		Lighting Off
		ZWrite Off
		Offset -1, -1
		Fog{ Mode Off}
		ColorMask RGB
		Blend SrcAlpha OneMinusSrcAlpha


		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
				sampler2D _MainTex;
				sampler2D _MaskTex;
				float4 _MainTex_ST;

				struct appdata_t {
					float4 vertex:POSITION;
					half4 color:COLOR;
					float2 texcoord:TEXCOORD0;
				};

				struct v2f {
					float4  pos : SV_POSITION;
					float2  texcoord : TEXCOORD0;
					float4 color:COLOR;
					float2 worldPos:TEXCOORD1;
				};

				v2f vert(appdata_t v)
				{
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
					o.color = v.color;
					o.texcoord = v.texcoord;
					o.worldPos = TRANSFORM_TEX(v.vertex.xy,_MainTex);

					//	o.uv = v.vertex.xz;
						return o;
					}

				float4 frag(v2f i) : COLOR
				{
					float2 panelUV = (1 - i.worldPos)*0.5f;
					half4 col = tex2D(_MainTex,i.texcoord)*i.color;
					col.a *= tex2D(_MaskTex,panelUV).a;
					return col;

				}

			ENDCG
			}
	}
}


