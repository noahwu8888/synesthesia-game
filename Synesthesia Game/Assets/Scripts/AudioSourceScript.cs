using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMOD.Studio;
public class AudioSourceScript : MonoBehaviour
{
    FMOD.Studio.EventInstance instance;
    public string fmodEvent;

    public string parameterName;
    

    public float shouldLoop;

    // Start is called before the first frame update
    void Start()
    {
        instance = FMODUnity.RuntimeManager.CreateInstance(fmodEvent);
        instance.start();
    }

    // Update is called once per frame
    void Update()
    {
        instance.setParameterByName(parameterName, shouldLoop);
    }
}
