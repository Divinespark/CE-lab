prompt = 'Select one of the following processes: \n (a) Perform FIR filtering \n (b) Extract signal segments \n (c) Calculate energy for specified frequency regions \n (d) Modelling of energy values using Gaussian PDF \n (e) Exit the program \n (f) advance \n (s) break the loop \n';
choice = input(prompt,'s');
while(choice)

    switch (choice)
        case 'a'
            readtext
        case 'b'
            sectionB
        case 'c'
            topic_c
        case 'd'
            topic_d
        case 'e'
            exit
        case 'f'
            fir
        case 's'
            break
        otherwise
            disp('Invalid choice')
     end
    choice = input("input 's' to break loop or 'e' to exit ",'s');
end
