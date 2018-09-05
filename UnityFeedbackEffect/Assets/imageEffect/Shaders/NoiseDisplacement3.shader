// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CustomImageEffect/NoiseDisplacement3" {
    // シェーダのプロパティ。必要なら追加する。
    Properties {
        // 入力画像がここにはいる
        _MainTex ("Source", 2D) = "white" {}
        _Strength("_Strength", float ) = 1

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
            float faceRadius;
            float waveForce;
            float _Strength;
            sampler2D _MainTex;
            float _Brightness;


            float2 getWiggleUV(float2 uv) {

              float distanceFromFace = max(0., length((uv - faceCenter) * float2(16. / 9., 1.)) - faceRadius * 0.5 * (1. - rate));

              // zoom
              float2 _uv = (uv - faceCenter) * (1. + rate - distanceFromFace * rate) + faceCenter;

              // wiggle
              float force = lerp(distanceFromFace * waveForce, waveForce * 2., rate);
              _uv.x += snoise(lerp(uv.x * 300.5, uv.y * 200.5, _Time.x )) * force;
              _uv.y += snoise(lerp(uv.x * 400.1, uv.y * 100.3, _Time.x )) * force;

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
                fixed2 pos = i.uv - fixed2(0.5,0.5);
                
                //kyoku
                float amp = length( pos );
                float rad = atan2( pos.y, pos.x );

                //amp += snoise(float3(amp,rad,_Time.x)) * 0.1;
                //rad += snoise(float3(rad,amp,_Time.x+10)) * 0.1;
                
                amp = lerp( amp,amp+snoise(float3(pos.x,pos.y,_Time.x)) * 0.2, min(amp*5,1));
                rad += snoise(float3(pos.x*3,pos.y*3,_Time.x+10)) * 0.8;

                //amp = max(amp,0);

                fixed2 pp = fixed2(0,0);

                pp.x = 0.5 + amp * cos(rad);
                pp.y = 0.5 + amp * sin(rad);
                */

                fixed2 pp = fixed2(0,0);
                pp.x = i.uv.x + 0.03 * snoise( float3( i.uv.x * 0.3, i.uv.y * 0.4, _Time.y*1.2 ) );
                pp.y = i.uv.y + 0.03 * snoise( float3( i.uv.x * 0.6, i.uv.y * 0.5, _Time.y*1.7 ) );
                

                //fixed4 colBase = tex2D(_MainTex,i.uv);

                fixed2 uv = pp;
                uv = clamp(uv,0,1);

                fixed4 col = tex2D(_MainTex, uv)*1.1;

                //
                //col.xyz = col.xyz - colBase.xyz;

                return col;

            }
            ENDCG
        }
    }
    FallBack Off
}