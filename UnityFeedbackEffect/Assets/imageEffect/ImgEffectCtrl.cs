
    using JetBrains.Annotations;
    using UnityEngine;

    public class ImgEffectCtrl : MonoBehaviour
    {
        
        [SerializeField] public NoiseDisplaceEffect camEffect1;
        [SerializeField] public NoiseDisplaceEffect camEffect2;

        [SerializeField] public LoopEffect loopEffect1;
        [SerializeField] public LoopEffect loopEffect2;

        public static ImgEffectCtrl Instance;

        void Awake()
        {
            Instance = this;
        }
        
        void Start()
        {
            //camEffect1
            //camEffect2
        }

        public void SetDisplacement(bool b)
        {
            camEffect1.enabled = b;
            camEffect2.enabled = b;            
        }

        public void SetLoop(bool b)
        {
            loopEffect1.enabled = b;
            loopEffect2.enabled = b;
        }
        
        public void SetDisplacementRatio(float r)
        {
            camEffect1.rate = r;
        }

        public void SetLoopRatio(float r)
        {
            loopEffect1.strength = r * 3f;
        }
        
        
        void Update()
        {
            if(camEffect1)
                camEffect1.UpdateMaterial();
    
            if(loopEffect1)
                loopEffect1.UpdateMaterial();
        }
        
    }
