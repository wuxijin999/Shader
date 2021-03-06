﻿Shader "GUI Effect/ImageSmoothMask"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}

		_Color("Tint", Color) = (1,1,1,1)

		_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255

		_ColorMask("Color Mask", Float) = 15

			_MaskTex("Mask Texture", 2D) = "white" {}
	}

		SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest[unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask[_ColorMask]

		Pass
		{
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _MaskRect;
			float _HorizontalRate = 0;
			float _VerticalRate = 0;

			float2 SelfUVCalculate(float2 vertex)
			{
				float width = _MaskRect.z - _MaskRect.x;
				float height = _MaskRect.w - _MaskRect.y;

				float u = (vertex.x - _MaskRect.x) / width;
				float v = (vertex.y - _MaskRect.y) / height;

				return float2(u, v);
			}

			float MaskCalculate(float a, float2 uv)
			{
				a *= uv.x < _HorizontalRate ? smoothstep(0,1,uv.x / _HorizontalRate) : 1;
				a *= uv.x > 1 - _HorizontalRate ? smoothstep(0, 1, (1 - uv.x) / _HorizontalRate) : 1;
				a *= uv.y < _VerticalRate ? smoothstep(0, 1, uv.y / _VerticalRate) : 1;
				a *= uv.y > 1 - _VerticalRate ? smoothstep(0, 1, (1 - uv.y) / _VerticalRate) : 1;

				return a;
			}

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 texcoord1: TEXCOORD1;
			};

			fixed4 _Color;

			v2f vert(appdata_t IN)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
				o.texcoord = IN.texcoord;
				o.texcoord1 = IN.vertex;
			#ifdef UNITY_HALF_TEXEL_OFFSET
				o.vertex.xy += (_ScreenParams.zw - 1.0)*float2(-1,1);
			#endif
				o.color = IN.color * _Color;
				return o;
			}

			sampler2D _MainTex;
			sampler2D _MaskTex;
			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = tex2D(_MainTex, IN.texcoord) * IN.color;
				color.a = MaskCalculate(color.a, SelfUVCalculate(IN.texcoord1));
				color.a *= tex2D(_MaskTex, IN.texcoord).a;
				clip(color.a - 0.01);

				return color;

				}
				ENDCG
			}
	}
}
