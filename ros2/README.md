# ROS2 communication exercises

The final course laboratories introduced ROS2 as middleware for modular
industrial applications.

## Part 1: nodes, topics and graphs

- launched and controlled Turtlesim;
- inspected velocity commands on `/turtle1/cmd_vel`;
- used `ros2 topic echo` to observe messages; and
- visualised node/topic relationships with `rqt_graph`.

## Part 2: services and actions

A supplied smart-factory package was used to inspect how a controller interacts
with a conveyor and processor:

- `/part` carried information about moving parts;
- `/controller_event` reported detection and controller decisions;
- `/remove_part` used request/response service communication; and
- the processing action handled work that takes time and can provide feedback.

The assignment modification extended the controller condition from processing
only red parts to processing both red and blue parts:

```python
if part_type == "red" or part_type == "blue":
    self.publish_event("processing_started", part_id)
    self.call_remove_service(part_id)
    self.send_goal(data)
else:
    self.publish_event("ignored", part_id)
```

The surrounding smart-factory package was supplied by the course and is not
redistributed or claimed as personally authored.
