<?php
namespace App\DTOs;

class ApplicationDTO
{
    public int $candidateId;
    public int $jobId;

    public function __construct(array $data)
    {
        $this->candidateId = $data['candidate_id'];
        $this->jobId = $data['job_id'];
    }
}