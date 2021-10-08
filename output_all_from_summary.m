function output_all_from_summary(SampleList,dir_name)

    install_CARLIN
    %% start the analysis
    sample_name_array=split(SampleList,',');

    curr_dir=pwd;
    for j = 1:length(sample_name_array)

        %% prepare file and folder
        
        sample_name=sample_name_array(j);
        disp("Current sample: "+sample_name)
        
        output_dir=dir_name+"/"+sample_name;
        mkdir(output_dir)
        cd(output_dir)
        %%% plotting
        if exist(output_dir+"/Summary.mat") == 2
            load(output_dir+'/Summary.mat')

            save_dir='.';
            generate_text_output(summary, params, thresholds, save_dir);

            fprintf('Generating allele plot\n');

            warning('off', 'MATLAB:hg:AutoSoftwareOpenGL');
            plot_summary(summary, output_dir);

%             fprintf('Generating diagnostic plot\n');
%             if (strcmp(cfg.type, 'Bulk'))    
%                 suspect_alleles = plot_diagnostic(cfg, FQ, aligned, tag_collection_denoised, tag_denoise_map, tag_called_allele, ...
%                                                   summary, thresholds, params.Results.outdir);
%             else
%                 suspect_alleles = plot_diagnostic(cfg, FQ, aligned, tag_collection_denoised, tag_denoise_map, tag_called_allele, ...
%                                                   summary, thresholds, ref_CBs, params.Results.outdir);
%             end
          
            
            plot_highlighted_alleles(summary, length(summary.alleles)-1);
            %     file_name="plot_highlighted_alleles.eps";
            %     print('-depsc2','-painters',file_name);
            file_name=save_dir+"/highlight_alleles.png";
            saveas(gcf,file_name)

            close all
            plot_allele_frequency_CDF(summary, 'Eyeball')
            file_name=save_dir+"/plot_allele_frequency_CDF.eps";
            print('-depsc2','-painters',file_name);

            close all
            plot_indel_freq_vs_length(summary)
            file_name=save_dir+"/plot_indel_freq_vs_length.eps";
            print('-depsc2','-painters',file_name);

            %this is not working for the Tigre carlin data
            close all
            plot_site_decomposition(summary, true, 'Eyeball', '# of Transcripts')
            file_name=save_dir+"/plot_site_decomposition.eps";
            print('-depsc2','-painters',file_name);

            plot_stargate.create(summary)
            file_name=save_dir+"/plot_stargate.png";
            saveas(gcf,file_name)
            
        else
            disp("Warning: Sample"+string(sample_name)+"has not been computed")


        end
    end
    cd(curr_dir)
    
    

    

    
    