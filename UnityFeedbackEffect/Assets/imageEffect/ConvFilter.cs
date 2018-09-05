using UnityEngine;
using System.Collections;
using System;

public class ConvFilter : MonoBehaviour {
    [Tooltip("マスクパターンを実装するシェーダを持つマテリアル")]
    public Material mat;
    [Tooltip("マスク。3x3の部分しか使用しない。")]
    public Matrix4x4 matrix;
    [Tooltip("基本的にはマスク数の9、適用しないマスク値0の分の明度が必要な場合等で変更。")]
    public Matrix4x4 matrix2;

    public float _Dist = 1;

    private Matrix4x4 currentMatrix;

    public float div = 9;

    void Start(){
        currentMatrix = matrix;
    }
    void Update(){
        if(Input.GetKeyDown(KeyCode.Alpha1)){
            currentMatrix = matrix;
        }
        if(Input.GetKeyDown(KeyCode.Alpha2)){
            Debug.Log("keydown2");
            currentMatrix = matrix2;
        }
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {


        mat.SetFloat("_TexWidth", source.width);
        mat.SetFloat("_TexHeight", source.height);
        mat.SetMatrix("_Matrix", currentMatrix);
        mat.SetFloat("_Div", div);
        mat.SetFloat("_Dist", _Dist);
        Graphics.Blit(source, destination, mat);
    }
}