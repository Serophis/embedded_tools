import os
import sys
import yaml
import re

def replace_parenthesis_content_by_dict(string, params_dict):
    # Regular expression to match the parenthesis content
    pattern = re.compile(r'\([^)]*\)')
    
    # Function to replace the captured group matching the pattern
    def replace(match):
        param_list = match.group(0)
        param_list = param_list[1:-1]
        splitted = param_list.split(',')
        string_content = "("
        for key in splitted:
            key = key.strip()
            if key in params_dict:
                string_content += f"{key}: {params_dict[key]}, "
            else:
                raise ValueError("ERROR IN DICT")  # Not supposed to be reached
        return string_content
    
    # Call the function to replace the parenthesis content by the parameters and their types
    string_with_params_and_type = re.sub(pattern, replace, string)
    # Remove the last comma and space and add the closing parenthesis
    string_with_params_and_type = str.removesuffix(string_with_params_and_type, ', ') + ")"
    return string_with_params_and_type

def generate_context_diagram_latex_description(data):
    # Prepare header of the LaTeX generated file
    header = "% AUTOMATICALLY GENERATED WITH generate_actor_interfaces.py\n"
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
                    
                    params_dict = action_details.get('params', {})
                    if params_dict:
                        action_name = replace_parenthesis_content_by_dict(action_name, params_dict)
                    
                    current_interaction_str += f"\\underline{{{action_name}{return_type_str}}} --- {action_details['description']}\\newline\n"
            current_interaction_str += "\n"
        current_interaction_str += "\n"
        latex_description += current_interaction_str
    
    latex_description = latex_description.replace("_", "\_")
    return header + latex_description


def main():
    script_path = f"{os.path.abspath(__file__)}"
    script_dir = os.path.split(script_path)[0]
    print("Script dir =", script_dir)

    # Open the YAML file with the data and create a string containing the diagram
    with open(f"{script_dir}/../../data/context_data.yaml", "r") as yaml_file:
        data = yaml.safe_load(yaml_file)
        context_diagram_latex_description = generate_context_diagram_latex_description(data)
        print("==========Context_diagram LaTeX===============\n")
        print(context_diagram_latex_description) # Print the string containing the diagram

    # Write the string content to a file
    if len(sys.argv) < 2:  # If file path not specified, it's hardcoded
        with open("interfaceAvecLesActeurs.tex", "w") as context_diagram_file:
            context_diagram_file.write(context_diagram_latex_description)

    else:  # If file path specified as first argument, use it
        with open(f"{sys.argv[1]}/2.2.2.2.interfaceAvecLesActeurs.tex", "w") as context_diagram_file:
            context_diagram_file.write(context_diagram_latex_description)


if __name__ == "__main__":
    main()
