import os
import sys
import yaml
import re

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
                        
                    action_name_with_params = action_name + "()" # Default value, simply add parenthesis
                    if 'params' in action_details:
                        params_dict = action_details['params']
                        action_name_with_params = action_name + "(" + ", ".join(params_dict.keys()).removesuffix(", ") + ")" # Add and fill the parenthesis with the parameters and their types
                    # For each action in the interaction
                    interactions_string += f"{action_name_with_params}{return_str} {dir}\\n "
        interactions_string += "\n"

    # Create the diagram
    diagram_header = "@startuml context_diagram\n\n"
    diagram_footer = "\n@enduml"
    context_diagram = diagram_header + actors_string + \
        interactions_string + diagram_footer
    return context_diagram

def generate_context_description(data):
    # Prepare header of the LaTeX generated file
    header = f"% AUTOMATICALLY GENERATED WITH {os.path.basename(__file__)}\n"
    "\paragraph{Interfaces avec les acteurs}  % 2.2.2.2 Interfaces avec les acteurs"
    # The string to fill
    latex_description = ""
    
    # For each interaction from the list of interactions
    for interaction_name, directions in data.items():
        current_interaction_str = ""
        interactors_couple = interaction_name.split("2")
        
        # For each direction and its actions
        for direction, actions in directions.items():
            interactors_couple = [interactors_couple[0], interactors_couple[1]] if direction == "forward" else [interactors_couple[1], interactors_couple[0]]
            current_interaction_str += f"\\textbf{{De {interactors_couple[0]} vers {interactors_couple[1]}}}\\newline\n"
            
            for action in actions:
                for action_name, action_details in action.items():
                    return_type_str = ""
                    if 'return' in action_details:
                        return_type_str = f" : {action_details['return']}"
                    
                    action_name_with_params = action_name + "()" # Default value, simply add parenthesis
                    if 'params' in action_details:
                        params_dict = action_details['params']
                        params_string = ", ".join("{}: {}".format(key, value) for key, value in params_dict.items()).replace("'", "").replace("{", "").replace("}", "").removesuffix(", ")
                        action_name_with_params = action_name + "(" + params_string + ")"
                    
                    current_interaction_str += f"\\underline{{{action_name_with_params}{return_type_str}}} --- {action_details['description']}\\newline\n"
            current_interaction_str += "\n"
        current_interaction_str += "\n"
        latex_description += current_interaction_str
    
    latex_description = latex_description.replace("_", "\_")
    return header + latex_description

def main():
    # Check if the user provided enough arguments to the script
    if len(sys.argv) < 4:
        print(f"Error, not enough arguments provided. Usage: python3 {os.path.basename(__file__)} <input_yaml_file> <output_plantuml_file> <output_latex_file>"
              f"For example: python3 {os.path.basename(__file__)} ../../communs/data/context_data.yaml ../../specification/schemas/context_diagram.plantuml ../../specification/ebauches/sections/2.DescriptionGenerale/2.2.2.2.interfaceAvecLesActeurs.tex")
    else:
        # Open the YAML file with the data and create a string containing the diagram
        with open(f"{sys.argv[1]}", "r") as yaml_file:
            data = yaml.safe_load(yaml_file)
            context_diagram = generate_context_diagram(data)
            yaml_file.close()
            print("=============context_diagram================\n")
            print(context_diagram)
            print("==========context_description===============\n")
            context_description = generate_context_description(data)
            print(context_description)
        
        # Write the strings content to dedicated files
        with open(f"{sys.argv[2]}", "w") as context_diagram_file:
            context_diagram_file.write(context_diagram)
            context_diagram_file.close()
        with open(f"{sys.argv[3]}", "w") as context_description_file:
            context_description_file.write(context_description)
            context_description_file.close()

if __name__ == "__main__":
    main()
