using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathPlaneScript : MonoBehaviour
{
    public RoomManager RoomManager;
    void Start()
    {
        RoomManager = transform.parent.GetComponent<RoomManager>();
    }


    [ContextMenu("Respawn Player")]
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            RoomManager.respawnCharacter();
        }
    }
}
