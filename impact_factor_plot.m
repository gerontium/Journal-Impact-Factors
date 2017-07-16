clear
close all
clc

% read in impact factor list
[num,txt,raw] = xlsread('C:\Users\loughnge\Dropbox\Maps\Journal Impact Factors\JCR_2015.xls');
% 1: Rank
% 2: Name
% 6: Impact Factor
% 7: 5-Year Impact Factor

raw = raw(4:end-1,[2,6,7]);
raw(find(strcmp(raw(:,2),'Not Available') | strcmp(raw(:,3),'Not Available')),:) = [];

journal_names = caseconvert(raw(:,1),'upper');
impact_factor = str2double(raw(:,2));
impact_factor5 = str2double(raw(:,3));

% read in 1st neuro journal list
[num,txt,raw] = xlsread('C:\Users\loughnge\Dropbox\Maps\Journal Impact Factors\scimagojr.xlsx');
neuro_journals = raw(2:end,2);

% read in 2nd neuro journal list
[num,txt,raw] = xlsread('C:\Users\loughnge\Dropbox\Maps\Journal Impact Factors\neuro_journals.xlsx');
neuro_journals = [neuro_journals;raw];

% convert to upper case
neuro_journals = caseconvert(neuro_journals,'upper');
% add my journals if necessary
my_journals = {'CORTEX','NEUROREPORT','CURRENT BIOLOGY','SCIENTIFIC REPORTS','NEUROPSYCHOLOGIA','JOURNAL OF NEUROSCIENCE','PLOS BIOLOGY'}';
neuro_journals = [neuro_journals;my_journals];
% get unique journals
[neuro_journals,ia,ic] = unique(neuro_journals);
neuro_journal_IFs = NaN(length(neuro_journals),1);

% take out review journals?
review_journals = {'NATURE REVIEWS NEUROSCIENCE';'BEHAVIORAL AND BRAIN SCIENCES';'ANNUAL REVIEW OF NEUROSCIENCE'; ...
    'TRENDS IN NEUROSCIENCES';'PROGRESS IN NEUROBIOLOGY';'ANNALS OF NEUROLOGY';'CURRENT OPINION IN NEUROBIOLOGY'};

% match neuro journals to database
unlisted_neurojs={};
for i = 1:length(neuro_journals)
    jindx = find(strcmp(neuro_journals{i},journal_names));
    if jindx & isempty(find(strcmp(neuro_journals{i},review_journals)))
        jindx = jindx(1);
        neuro_journal_IFs(i) = impact_factor5(jindx);
    else
        unlisted_neurojs = [unlisted_neurojs;neuro_journals{i}];
    end
end

% get rid of nan breads
neuro_journals(find(isnan(neuro_journal_IFs))) = [];
neuro_journal_IFs(find(isnan(neuro_journal_IFs))) = [];

% sort if wanted
% [neuro_journal_IFs,indx] = sort(neuro_journal_IFs,'ascend');
% neuro_journals = neuro_journals(indx);

% randomise if wanted
% indx = randperm(length(neuro_journals));
% neuro_journal_IFs = neuro_journal_IFs(indx);
% neuro_journals = neuro_journals(indx);

% get my journal indices
[~,~,mjindx] = intersect(my_journals,neuro_journals);
my_journal_IFs = neuro_journal_IFs(mjindx);
% scatter_group = zeros(1,length(neuro_journals));
% scatter_group(mjindx) = 1;
scatter_group = repmat({'General Impact'},1,length(neuro_journals));
scatter_group(mjindx) = repmat({'My Impact'},1,length(my_journals));
scatter_group = scatter_group';

% plots
figure, plot(neuro_journal_IFs)
IF_med = median(neuro_journal_IFs);
IF_prc = prctile(neuro_journal_IFs,[10,25,50,75,90]);

cmap = colormap(gray); close
figure
h = scatter([1:length(neuro_journal_IFs)],neuro_journal_IFs,20,'filled'); hold on
h.MarkerFaceColor = cmap(32,:);
h1 = scatter(mjindx,my_journal_IFs,40,'filled');
h1.MarkerFaceColor = 'r';
line([xlim],[IF_med,IF_med],'Color','k','LineWidth', 2);
% xlabel('Journal','FontName','Arial'); % or axis off
ylabel('Impact Factor','FontName','Arial')
title('My Research Impact')
set(gca,'FontSize',16,'xticklabel',{})

%%
fonto = 'Trebuchet';
cmap = colormap(lines);
% image version
backpic = imread(['C:\Users\loughnge\Dropbox\Maps\Journal Impact Factors\backpic5.jpg']);
% backpic = backpic(1:end-130,:,:);
% -5   123
xImg = linspace(-5, 123, size(backpic, 2));
yImg = linspace(0, 18, size(backpic, 1));
figure
im = image(xImg, yImg, flipud(backpic), 'CDataMapping', 'scaled');
im.AlphaData = 1;
set(gca,'YDir','normal')
hold on;
for i = 4%3:length(IF_prc)
    line([xlim],[IF_prc(i),IF_prc(i)],'Color','k','LineWidth', 1);
end

h = scatter([1:length(neuro_journal_IFs)],neuro_journal_IFs,20,'filled'); hold on
h.MarkerFaceColor = cmap(9,:);
% h.MarkerFaceColor = 'b';
h.MarkerEdgeColor = 'k';
h1 = scatter(mjindx,my_journal_IFs,100,'filled');
h1.MarkerFaceColor = cmap(3,:);
% h1.MarkerFaceColor = 'r';
h1.MarkerEdgeColor = 'k';
% line([xlim],[IF_med,IF_med],'Color','k','LineWidth', 2);
% for i = 1:length(IF_prc)
%     line([xlim],[IF_prc(i),IF_prc(i)],'Color','k','LineWidth', 1);
% end
% xlabel('Journal','FontName',fonto); % or axis off
% ylabel('Lower Impact <<<->>> Higher Impact','FontName',fonto)
ylabel('Impact Factor','FontName',fonto)
% title('My Research Impact','FontName',fonto)
legend([h,h1], {'General Impact', 'My Impact'},'Location','NorthWest')
% set(gca,'position',[0.15 0.15 0.7 0.7],'FontSize',16,'xtick',[],'ylim',[0,18],'FontName',fonto)
set(gca,'FontSize',16,'xtick',[],'ylim',[0,18],'FontName',fonto)
box off