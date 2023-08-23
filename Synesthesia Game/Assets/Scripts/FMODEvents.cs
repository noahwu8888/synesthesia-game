using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FMODUnity;

public class FMODEvents : MonoBehaviour
{
    [field: Header("Level Events")]
    [field: SerializeField] public EventReference LevelEvent{get; private set;}



    public static FMODEvents instance { get; private set; }
    private void Awake()
    {
        if (instance != null)
        {
            Debug.LogError("Duplicate Audio Manager Found");
        }
        instance = this;
    }
}
