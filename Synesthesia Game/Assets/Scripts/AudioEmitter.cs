using UnityEngine; //noah has a small penis
using System.Collections.Generic;
using FMODUnity;

[RequireComponent(typeof(StudioEventEmitter))]
public class AudioEmitter : MonoBehaviour
{
    public static AudioEmitter instance { get; private set; }

    public StudioEventEmitter levelEmitter;


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
            Debug.LogError("Duplicate Audio levelEmitter Found");
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

        levelEmitter = AudioManager.instance.InitializeEventEmitter(FMODEvents.instance.levelEvent, this.gameObject);
        AudioManager.instance.InitializeAmbience(FMODEvents.instance.backgroundEvent);
        StartEmitter();
    }
    private void FixedUpdate()
    {
        SetRoomNumber(currentRoom);
    }

    public void SetRoomNumber(float parameterValue)
    {
        levelEmitter.SetParameter("Room Number", parameterValue, false);
        AudioManager.instance.backgroundInstance.setParameterByName("Room Number", parameterValue, false);
    }

    public void StartEmitter()
    {
        levelEmitter.Play();
    }

}
