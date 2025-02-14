<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\DTOs\CandidateDTO;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CandidateController extends Controller
{
    public function create(Request $request)
    {
        $validated = $request->validate([
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'email' => 'required|email|unique:candidates,email',
            'phone' => 'nullable|string',
            'resume' => 'nullable|string',
        ]);

        $candidateDTO = new CandidateDTO($validated);

        DB::statement('CALL CreateCandidate(:first_name, :last_name, :email, :phone, :resume)', [
            $candidateDTO->first_name,
            $candidateDTO->last_name,
            $candidateDTO->email,
            $candidateDTO->phone,
            $candidateDTO->resume
        ]);

        return response()->json(['message' => 'Candidate created successfully'], 201);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'phone' => 'required|string',
            'resume' => 'nullable|string',
        ]);

        DB::statement('CALL UpdateCandidate(:id, :email, :phone, :resume)', [
            ':id' => $id,
            ':email' => $validated['email'],
            ':phone' => $validated['phone'],
            ':resume' => $validated['resume'] ?? null, // Asignar null si 'resume' es nulo
        ]);

        return response()->json(['message' => 'Candidate updated successfully'], 200);
    }

    public function delete(Request $request)
    {
        $validated = $request->validate([
            'id' => 'required|integer|exists:candidates,id',
        ]);

        DB::statement('CALL DeleteCandidate(:id)', [
            'id' => $validated['id'],
        ]);

        return response()->json(['message' => 'Candidate deleted successfully'], 200);
    }

    public function index()
    {
        $candidates = DB::select('CALL GetAllCandidates()');
        return response()->json($candidates, 200);
    }
}
