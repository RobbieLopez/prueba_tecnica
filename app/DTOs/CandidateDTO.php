<?php
namespace App\DTOs;

class CandidateDTO
{
    public string $first_name;
    public string $last_name;
    public string $email;
    public ?string $phone;
    public ?string $resume;

    public function __construct(array $data)
    {
        $this->first_name = $data['first_name'];
        $this->last_name = $data['last_name'];
        $this->email = $data['email'];
        $this->phone = $data['phone'] ?? null;
        $this->resume = $data['resume'] ?? null;
    }
}
