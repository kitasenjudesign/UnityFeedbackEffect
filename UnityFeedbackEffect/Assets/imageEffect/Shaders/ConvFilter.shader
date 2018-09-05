// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ConvFilter"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_TexWidth ("display name", Float) = 512
		_TexHeight ("display name", Float) = 512
		_Dist ("_Dist", Float) = 1
    }

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            uniform float _TexWidth;
            uniform float _TexHeight;
            uniform matrix _Matrix;
			uniform float _Dist;
            uniform float _Div;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 ret_col;
                int u, v;
                for (u = -1; u < 2; ++u)
                    for (v = -1; v < 2; ++v)
                    {
                        float x = i.uv.x + u / _TexWidth * _Dist;
                        float y = i.uv.y + v / _TexHeight * _Dist;
                        ret_col += tex2D(_MainTex, float2(x, y))*_Matrix[u + 1][v + 1];
                    }
                return ret_col / _Div;
            }
            ENDCG
        }
    }
}