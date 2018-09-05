// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CustomImageEffect/NoiseDisplacement" {
    // シェーダのプロパティ。必要なら追加する。
    Properties {
        // 入力画像がここにはいる
        _MainTex ("Source", 2D) = "white" {}
        _SnowTex ("SnowSource", 2D) = "black" {}
        _Brightness ("Brightness", Float) = 1

        //saq

        rate("rate", Float) = 0.5
        frame("frame", Float) = 1
        //faceCenter("faceCenter", Float) = 0.5
        faceRadius("faceRadius", Float) = 0.5
        waveForce("waveForce", Float) = 0.5

        /*
            float rate;
            float frame;
            vec2 faceCenter;
            float faceRadius;
            float waveForce;
        */

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
            #include "SimplexNoise3D.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //uvの計算をする

            float rate;
            float frame;
            float2 faceCenter;
            float2 noiseDetail;
            float faceRadius;
            float waveForce;



            sampler2D _SnowTex;
            sampler2D _MainTex;
            float _Brightness;


            float2 getWiggleUV(float2 uv, float ff) {


              float distanceFromFace = max(0., length((uv - faceCenter) * float2(16. / 9., 1.)) - faceRadius * 0.5 * (1. - rate));

              // zoom
              float2 _uv = (uv - faceCenter) * (1. + rate - distanceFromFace * rate) + faceCenter;

              // wiggle
              float force = lerp(distanceFromFace * waveForce, waveForce * 2., rate);


              //_uv.x += snoise(lerp(uv.x * 0.5, uv.y * 0.5, frame * 0.01)) * force;
              //_uv.y += snoise(lerp(uv.x * 0.1, uv.y * 0.3, frame * 0.01)) * force;


              //float2 _uv = uv;
              _uv.x += snoise(
                float3( (uv.x-0.5)*noiseDetail.x,(uv.y-0.5f)*noiseDetail.y,frame*0.01 + ff)
              ) * waveForce;
              
              _uv.y += snoise(
                float3( (uv.x-0.5)*noiseDetail.x*0.93,(uv.y-0.5f)*noiseDetail.y*0.91,frame*0.015 + ff)
              ) * waveForce * 0.1;

             //強さの割合的な

                float rx = pow( 2.0 * abs(uv.x - 0.5), 1 );
                float ry = pow( 2.0 * abs(uv.y - 0.5), 2 );


            _uv.x = lerp(_uv.x, uv.x, rx);
            _uv.y = lerp(_uv.y, uv.y, ry);

                //_uv.x = uv.x;

              return _uv;
            }


             //////////

            v2f vert(appdata_img v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord.xy);
                //o.uv = getWiggleUV(MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord.xy));
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                
                // ここに表示したい色の計算処理を書く
                
                /*
                fixed4 colR = tex2D(_MainTex, getWiggleUV(i.uv,0.19));//col1
                fixed4 colG = tex2D(_MainTex, getWiggleUV(i.uv,0.11));//col1
                fixed4 colB = tex2D(_MainTex, getWiggleUV(i.uv,0.03));//col1
                fixed4 col = fixed4(colR.r,colB.g,colG.b,colR.a);
                */
                
                float2 uv = (1.0-rate) * i.uv + rate * getWiggleUV(i.uv,0);
                
                fixed4 col = tex2D(_MainTex, uv);
                fixed4 col2 = tex2D(_SnowTex, i.uv);
                
                fixed4 output = lerp(col2, col, step(0.2, length(col.rgb)));
                
                return output;

            }
            ENDCG
        }
    }
    FallBack Off
}