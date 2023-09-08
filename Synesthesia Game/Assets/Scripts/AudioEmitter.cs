using UnityEngine;
using System.Collections.Generic;
using FMODUnity;

[RequireComponent(typeof(StudioEventEmitter))]
public class AudioEmitter : MonoBehaviour
{
    public static AudioEmitter instance { get; private set; }

    public StudioEventEmitter emitter;

    [System.Serializable]
    public class RoomInfo
    {
        public GameObject roomObject;
        public Transform startPos;
        public Transform endPos;
    }

    public List<RoomInfo> roomList = new List<RoomInfo>();

    public int currentRoom;


    private void Awake()
    {
        if (instance != null)
        {
            Debug.LogError("Duplicate Audio Emitter Found");
        }
        instance = this;
        currentRoom = 1;
    }
    private void Start()
    {
        foreach (RoomInfo roomInfo in roomList)
        {
            Transform startPos = roomInfo.roomObject.transform.Find("Music Logic/Start Pos");
            Transform endPos = roomInfo.roomObject.transform.Find("Music Logic/End Pos");

            if (startPos != null && endPos != null)
            {
                roomInfo.startPos = startPos;
                roomInfo.endPos = endPos;
            }
            else
            {
                Debug.LogError("Start or End position not found for room: " + roomInfo.roomObject.name);
            }
        }

        emitter = AudioManager.instance.InitializeEventEmitter(FMODEvents.instance.levelEvent, this.gameObject);
        StartEmitter();

    }
    private void FixedUpdate()
    {
        SetRoomNumber(currentRoom);
    }

    public void SetRoomNumber(float parameterValue)
    {
        emitter.SetParameter("Room Number", parameterValue, false);
    }

    public void StartEmitter()
    {
        emitter.Play();
    }

}
