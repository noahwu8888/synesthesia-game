using UnityEngine;
using System.Collections.Generic;

public class AudioEmitter : MonoBehaviour
{
    [System.Serializable]
    public class RoomInfo
    {
        public GameObject roomObject;
        public Transform startPos;
        public Transform endPos;
    }

    public List<RoomInfo> roomList = new List<RoomInfo>();

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
    }
}
