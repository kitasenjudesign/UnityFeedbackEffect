// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CustomImageEffect/Gray" {
    // シェーダのプロパティ。必要なら追加する。
    Properties {
        // 入力画像がここにはいる
        _MainTex ("Source", 2D) = "white" {}

        _Brightness ("Brightness", Float) = 1
    }
    SubShader {
        // 不必要な機能はすべて切る
        ZTest Always
        Cull Off
        ZWrite Off
        Fog { Mode Off }

        Pass{
            // シェーダプログラムの本体
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata_img v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord.xy);
                return o;
            }

            sampler2D _MainTex;
            float _Brightness;

            fixed4 frag(v2f i) : SV_TARGET {
                // ここに表示したい色の計算処理を書く

                fixed4 col = tex2D(_MainTex, i.uv);
                fixed mean = (col.r + col.g + col.b) / 3.0;
                col.r = mean * _Brightness;
                col.g = mean * _Brightness;
                col.b = mean * _Brightness;
                return col;

            }
            ENDCG
        }
    }
    FallBack Off
}