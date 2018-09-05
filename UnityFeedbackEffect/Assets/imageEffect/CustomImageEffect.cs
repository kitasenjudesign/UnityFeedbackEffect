using UnityEngine;

[RequireComponent(typeof(Camera))]
public abstract class CustomImageEffect : MonoBehaviour
{
    #region Fields

    public Material m_Material;

    #endregion

    #region Properties

    public abstract string ShaderName { get; }

    protected Material Material { get { return m_Material; } }

    #endregion

    #region Messages

    protected virtual void Awake()
    {
        //Shader shader = Shader.Find(ShaderName);
        //m_Material = new Material(shader);
    }

    protected virtual void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //自分で呼ぶかどうか
        //UpdateMaterial();
        Graphics.Blit(source, destination, m_Material);
    }

    #endregion

    #region Methods

    public abstract void UpdateMaterial();

    #endregion

}