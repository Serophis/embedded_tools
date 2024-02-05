import os
import sys
import yaml

def generate_context_diagram(data):
    actors = []
    interactions_string = ""

    for interaction_name, directions in data.items():
        # List actors in a deduplicated list
        interactors_couple = interaction_name.split("2")
        actors.extend(interactors_couple)
        actors = list(dict.fromkeys(actors))
        actors_string = "".join([f"actor {actor}\n" for actor in actors])

        # Create a list of interactions
        interactions_string += f"{interactors_couple[0]} -- {interactors_couple[1]} : "
        
        # For each interaction from the list of interactions
        for direction, actions in directions.items():
            if direction == "forward":
                dir = ">"
            else:
                dir = "<"
            
            for action in actions:
                for action_name, action_details in action.items():
                    return_str = ""
                    if 'return' in action_details:
                        return_str = " : " + action_details['return']
                    # For each action in the interaction
                    interactions_string += f"{action_name}{return_str} {dir}\\n "
        interactions_string += "\n"

    # Create the diagram
    diagram_header = "@startuml context_diagram\n\n"
    diagram_footer = "\n@enduml"
    context_diagram = diagram_header + actors_string + \
        interactions_string + diagram_footer
    return context_diagram

def main():
    script_path = f"{os.path.abspath(__file__)}"
    script_dir = os.path.split(script_path)[0]
    print("Script dir =", script_dir)

    # Open the YAML file with the data and create a string containing the diagram
    with open(f"{script_dir}/data/context_data.yaml", "r") as yaml_file:
        data = yaml.safe_load(yaml_file)
        context_diagram = generate_context_diagram(data)
        print("==========context_diagram===============\n")
        print(context_diagram)

    # Write the string content to a file
    if len(sys.argv) < 2:  # If file path not specified, it's hardcoded
        with open("context_diagram.plantuml", "w") as context_diagram_file:
            context_diagram_file.write(context_diagram)

    else:  # If file path specified as first argument, use it
        with open(f"{sys.argv[1]}/context_diagram.plantuml", "w") as context_diagram_file:
            context_diagram_file.write(context_diagram)


if __name__ == "__main__":
    main()
