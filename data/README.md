# data

We provide two csv files: data.csv, which contains the raw data of the
experiment, and demographics.csv, which contains the demographic information of
each subject. The datasets contain the following variables

`data.csv`

- `subid` : factor (sub001-sub019)
      the subject identifier

- `familiarity` : factor (Familiar, Stranger)
      the familiarity of the target

- `orientation` : factor (Inverted, Upright)
      the orientation of the target

- `target_sex` : factor (Female, Male)
      the sex of the target

- `target_presence` : factor (Target Absent, Target Present)
      whether the target was present or absent in the trial

- `set_size` : factor (2, 4, 6)
      number of stimuli presented in the trial (2, 4, 6)

- `target_position` : factor (0-6)
      position of the stimulus on the screen, coded as follows
    - 0 no target
    - 1-6 one of the possible 6 positions, where 1 is the upper right position,
      and the numbering continues in CCW order. Thus [5, 6, 1] are in the right
      hemifield, and [2, 3, 4] in the left

- `img1`-`img6` : string indicating filename
      image that was presented in one of the six position numbered as described
      above. when no image was presented in that location, the string 'none' is
      present.

- `stimuli_combination` : string
      the sorted combination of stimuli that appeared on the screen and that was
      used in the mixed-effects models as a random effect, when described in the
      methods

- `jitter` : float
      trial jitter in seconds

- `keypress` : int (-1, 0, 1)
      whether no response was given (-1), or the response was "Target Absent" (0)
      or "Target Present" (1)

- `correct `: int (0, 1)
      whether the response was correct (1) or incorrect (0)

- `RT` : int
      reaction time in ms


`demographics.csv`
- `subid` : factor (sub001-sub019)
    the subject identifier 

- `sex` : factor (f, m)
    sex of the subject

- `age` : int
    age of the subject
