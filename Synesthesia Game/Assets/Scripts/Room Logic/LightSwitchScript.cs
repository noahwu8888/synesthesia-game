using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class LightSwitchScript : MonoBehaviour
{

    public GameObject overlay;
    [SerializeField] private GameObject player;

    [SerializeField] private RoomManager currentRoom;

    [SerializeField] private bool isLightsOn = true;
    public string tagName = "Gates"; // Name of the tag you want to disable
    private GameObject[] objectsWithTag;

    void Start()
    {
        overlay.SetActive(false);
        // Find all GameObjects with the specified tag
        objectsWithTag = GameObject.FindGameObjectsWithTag(tagName);

        player = GameObject.FindWithTag("Player");
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            HitLights();
        }
    }
    private void HitLights()
    {
        if (isLightsOn)
        {
            overlay.SetActive(true);
            foreach (GameObject obj in objectsWithTag)
            {
                obj.SetActive(false);
            }
            //also respawn character if lights were on
            currentRoom.respawnCharacter();
            isLightsOn = false;
        }
        else
        {
            overlay.SetActive(false);
            foreach (GameObject obj in objectsWithTag)
            {
                obj.SetActive(true);
            }
            isLightsOn = true;
        }
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        if (other.CompareTag("Room"))
        {
            currentRoom = other.gameObject.GetComponent<RoomManager>();
        }
    }
}
